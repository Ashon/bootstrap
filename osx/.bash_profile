#!/bin/bash

# ls environ
export CLICOLOR=1
export LSCOLORS="exfxcxdxcxegedabagacad"

# ls aliases
alias ls='ls -GFh'
alias ll='ls -al'
alias la='ls -A'
alias l='ls -l'

# docker
alias dckm='docker-machine'
alias dck='docker'
alias dckco='docker-compose'

# python
alias python2='python2.7'

# ansible
alias apl='ansible-playbook'

# bash git prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=0
  GIT_PROMPT_THEME=Jwl
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

PYENV_ENABLED=true
if $PYENV_ENABLED; then

    # enable pyenv
    export PYENV_ROOT=/usr/local/var/pyenv
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
    if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

    # enable autoenv
    . /usr/local/opt/autoenv/activate.sh
fi

