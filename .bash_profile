export HOSTNAME=kobe
export HOSTNAME

export DOCKER_HOST="unix:///var/run/docker.sock"

export GRADLE_HOME=/usr/local/bin/gradle
export PATH=$GRADLE_HOME/bin:$PATH

export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/sbin
export PATH=$PATH:/usr/local/go/bin
export GOPATH=~/go
export PATH=${GOPATH//://bin:}/bin
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/usr/local/opt/node@8/bin:$PATH"
export PATH="/usr/local/opt/node@10/bin:$PATH"

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# git completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

# import aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi
