autoload -Uz add-zsh-hook

# zsh does not export HOSTNAME by itself; some build scripts read it. Derived, not
# hard-coded, so the file stays machine-neutral.
export HOSTNAME="${HOSTNAME:-$(hostname -s)}"

typeset -U path PATH
path=(
  $HOME/Library/pnpm
  /opt/homebrew/bin
  /opt/homebrew/sbin
  ${BUN_INSTALL:-$HOME/.bun}/bin
  /usr/local/sbin
  /sbin
  $HOME/.yarn/bin
  $HOME/.config/yarn/global/node_modules/.bin
  $path
  ~/bin
)
export PATH

# --- nvm: lazy load (node/npm/npx come from mise; nvm stays available on demand)
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
  nvm "$@"
}

if [ -f ~/.aliases ]; then
  . ~/.aliases
fi

# company/project-specific aliases, machine-local, not tracked in dotfiles
if [ -f ~/.aliases_company ]; then
  . ~/.aliases_company
fi

# --- fzf ---------------------------------
if [ -f ~/.fzf.zsh ]; then
  _load_fzf_once() { source ~/.fzf.zsh; add-zsh-hook -d precmd _load_fzf_once }
  add-zsh-hook precmd _load_fzf_once
fi

# --- iTerm2 shell integration ---------------------------------
# Guarded on the terminal, not just the file: the script emits OSC 1337 sequences
# unconditionally, which other emulators (Warp) render as garbage.
if [[ "$TERM_PROGRAM" == "iTerm.app" && -e ~/.iterm2_shell_integration.zsh ]]; then
  source ~/.iterm2_shell_integration.zsh
fi

# --- Docker completions ---------------------------------
fpath=(~/.docker/completions $fpath)
autoload -Uz compinit
# own dump path avoids recomputation; insecure-directory checks stay on
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-$ZSH_VERSION"
compinit -d "$ZSH_COMPDUMP"

# --- Bun completions ----------------------------------
[ -s ~/.bun/_bun ] && source ~/.bun/_bun

# disable telemetry transfers
export DO_NOT_TRACK=true
export NEXT_TELEMETRY_DISABLED=1
export GH_TELEMETRY=false

# portless
export PORTLESS_HTTPS=1
export PORTLESS_TLD=test

# git branch name in prompt (registered via hook so it coexists with fzf's precmd)
autoload -Uz vcs_info
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:git:*' formats ' (%b)'
setopt PROMPT_SUBST
PROMPT='%n@%m %~${vcs_info_msg_0_} %# '

# Point at colima only when its socket actually exists — otherwise leave DOCKER_HOST
# unset so Docker Desktop (or whatever the active docker context is) keeps working.
[ -S "$HOME/.colima/default/docker.sock" ] && export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"

export HOMEBREW_NO_ENV_HINTS=1
export PNPM_HOME="$HOME/Library/pnpm"

# GitHub token for tenv/mise release lookups (avoids API rate limits).
# Deliberately here and not in .zshenv: .zshenv runs before path_helper adds
# Homebrew to PATH, so gh is not found there, and a token set that early would
# be inherited by every non-interactive shell. Costs ~0.03s.
#
# Only exported when gh really hands one over — an expired login makes
# `gh auth token` print nothing, and an empty GITHUB_TOKEN is worse than none
# (tools treat it as "authenticated" and then get a 401).
if [[ -z "$GITHUB_TOKEN" ]] && command -v gh >/dev/null 2>&1; then
  _gh_token="$(gh auth token 2>/dev/null)"
  [[ -n "$_gh_token" ]] && export GITHUB_TOKEN="$_gh_token"
  unset _gh_token
fi
[[ -n "$GITHUB_TOKEN" ]] && : "${TENV_GITHUB_TOKEN:=$GITHUB_TOKEN}" && export TENV_GITHUB_TOKEN

# Load ssh keys whose passphrase is in the login Keychain into the agent.
# Needed for SSH commit signing: `ssh-keygen -Y sign` (which git calls) reads
# neither ssh_config nor the Keychain — it only consults a running agent, and
# launchd's agent starts empty after every login. Costs ~5ms and is a no-op when
# the keys are already loaded.
if [[ "$OSTYPE" == darwin* ]] && command -v ssh-add >/dev/null 2>&1; then
  ssh-add --apple-load-keychain --quiet 2>/dev/null
fi

# mise: polyglot version manager (Java, Gradle, Maven, Kotlin, ...)
command -v mise >/dev/null && eval "$(mise activate zsh)"

# JAVA_HOME / GRADLE_HOME are not exported by mise, but IDE run configurations and
# older build scripts read them. Derived from whatever is on PATH after mise has
# activated, so they follow the pinned versions instead of freezing a path.
if [[ -z "$JAVA_HOME" ]] && /usr/libexec/java_home >/dev/null 2>&1; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi
if [[ -z "$GRADLE_HOME" ]]; then
  # whence -p, not command -v: the latter would return an alias or function
  # definition for `gradle` instead of a path, and :h:h would mangle that.
  _gradle_bin="$(whence -p gradle)"
  # :A resolves the symlink first — a bare Homebrew shim would otherwise derive
  # /opt/homebrew as GRADLE_HOME. .../<version>/bin/gradle -> .../<version>
  [[ -n "$_gradle_bin" ]] && export GRADLE_HOME="${${_gradle_bin:A}:h:h}"
  unset _gradle_bin
fi

# pipx
export PATH="$PATH:$HOME/.local/bin"
