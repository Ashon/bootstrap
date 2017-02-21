#!/bin/bash

# ls aliases
alias ls='ls -G'
alias ll='ls -al'
alias la='ls -A'
alias l='ls -l'

# docker
alias dckm='docker-machine'
alias dck='docker'

# ansible
alias apl='ansible-playbook'

# bash git prompt
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  GIT_PROMPT_ONLY_IN_REPO=0
  GIT_PROMPT_THEME=Jwl
  GIT_PROMPT_LEADING_SPACE=0
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
