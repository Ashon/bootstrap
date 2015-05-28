#!/bin/sh

# update apt
sudo apt-get update

# install git, vim, nodejs, nodejs-legacy, npm
sudo apt-get -y install git vim nodejs nodejs-legacy npm

# install pylint pip
sudo apt-get -y install pylint python-pip

# install nmap tcpdump iotop iftop
sudo apt-get -y install nmap tcpdump iotop iftop

# install gnome-do
sudo apt-get -y install gnome-do

# install bash-git-prompt
git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt
