#!/bin/bash
# Things I want in a ubuntu installation

# Dev setup
sudo apt install vim vim-gnome
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install sublime-text-installer
sudo apt install git gitk
sudo apt install cscope

# Environment setup
sudo apt install dconf-editor

# Test setup
sudo apt install screen