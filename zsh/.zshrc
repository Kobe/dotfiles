# JAVA_HOME / Gradle / Maven / Kotlin are provided by mise (activated below)
autoload -Uz add-zsh-hook

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

# --- Docker completions ---------------------------------
fpath=(~/.docker/completions $fpath)
autoload -Uz compinit
# -C: skippt teure Sicherheitschecks (nutze -i, wenn du Checks willst)
# eigener Dump-Pfad verhindert Neuberechnung
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump-$ZSH_VERSION"
compinit -C -d "$ZSH_COMPDUMP"

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

export DOCKER_HOST="unix://$HOME/.colima/default/docker.sock"
export HOMEBREW_NO_ENV_HINTS=1
export PNPM_HOME="$HOME/Library/pnpm"

# mise: polyglot version manager (Java, Gradle, Maven, Kotlin, ...)
command -v mise >/dev/null && eval "$(mise activate zsh)"

# pipx
export PATH="$PATH:$HOME/.local/bin"
