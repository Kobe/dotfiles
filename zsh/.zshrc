export JAVA_HOME="$((/usr/libexec/java_home) 2>/dev/null)"
export GRADLE_HOME="/opt/homebrew/opt/gradle/libexec"

typeset -U path PATH
path=(
  /opt/homebrew/opt/node@22/bin
  /opt/homebrew/bin
  ${BUN_INSTALL:-$HOME/.bun}/bin
  ${GRADLE_HOME:+$GRADLE_HOME/bin}
  ${JAVA_HOME:+$JAVA_HOME/bin}
  /usr/local/sbin
  /sbin
  $HOME/.yarn/bin
  $HOME/.config/yarn/global/node_modules/.bin
  $path
  ~/bin
)
export PATH

# --- nvm: lazy load ----------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
_nvm_lazy() {
  unset -f nvm node npm npx
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
}
for _cmd in nvm node npm npx; do
  eval "$_cmd() { _nvm_lazy; $_cmd \"\$@\"; }"
done

if [ -f ~/.aliases ]; then
  . ~/.aliases
fi

# --- fzf ---------------------------------
if [ -f ~/.fzf.zsh ]; then
  autoload -Uz add-zsh-hook
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

# Next.js
export NEXT_TELEMETRY_DISABLED=1
