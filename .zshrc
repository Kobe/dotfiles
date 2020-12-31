export ZSH="/Users/kobe/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git colored-man-pages colorize pip python osx docker docker-compose emoji github iterm2 lighthouse mvn npm yarn gradle vagrant vscode)

source $ZSH/oh-my-zsh.sh

export HOSTNAME=KobeMac
export HOSTNAME

export GRADLE_HOME=/usr/local/bin/gradle
export JAVA_HOME="$(/usr/libexec/java_home -v 11)"
export DOCKER_HOST="unix:///var/run/docker.sock"

export PATH="$GRADLE_HOME/bin:$PATH"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="/sbin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

if [ -f ~/.aliases ]; then
  . ~/.aliases
fi
