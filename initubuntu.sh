#!/bin/bash
# Things I want in a ubuntu installation

# Dev setup
sudo apt install vim vim-gnome
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install sublime-text-installer
sudo apt install git gitk
sudo apt install cscope

# Build Linux kernel
sudo apt-get install libncurses5-dev gcc make git exuberant-ctags bc libssl-dev

# BATS - Bash Unit test framework, useful to learn new code
sudo apt install bats

# Gnu Dev setup
sudo apt install autoconf automake
sudo apt install autopoint texinfo flex

# Environment setup
sudo apt install dconf-editor
sudo apt install chromium-browser
# Note : Chromium comes without a PDF viewer by default.
# There is a PDF.js implementation in HTML5, needs an extension.

# Test setup
sudo apt install screen

# Python dev env
sudo apt install python-pip python-dev build-essential