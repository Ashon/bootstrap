#!/bin/sh

# update apt
sudo apt update && sudo apt upgrade -y

# install ansible
sudo apt install ansible

# install bash-git-prompt
git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt
