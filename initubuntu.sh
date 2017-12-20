#!/bin/bash
# Things I want in a ubuntu installation

# Dev setup
sudo apt install -y vim vim-gnome
sudo add-apt-repository ppa:webupd8team/sublime-text-3
sudo apt-get update
sudo apt-get install -y sublime-text-installer
sudo apt install -y git gitk
sudo apt install -y cscope

# Build Linux kernel
sudo apt-get install -y libncurses5-dev gcc make git exuberant-ctags bc libssl-dev

# BATS - Bash Unit test framework, useful to learn new code
sudo apt install -y bats

# Gnu Dev setup
sudo apt install -y autoconf automake
sudo apt install -y autopoint texinfo flex

# Environment setup
sudo apt install -y dconf-editor
sudo apt install -y chromium-browser
# Note : Chromium comes without a PDF viewer by default.
# There is a PDF.js implementation in HTML5, needs an extension.
# Configure Chromium : To start from where you left off:
# settings -> On startup -> Continue where you left off

# Useful feature for any window manager is the ability to save sessions.
# I want to start from where I left off in the last session.
# There is no way to do that in Ubuntu's UI called unity.
# This script gets around that problem
sudo apt-get install -y perl x11-utils wmctrl xdotool
wget http://raw.githubusercontent.com/hotice/webupd8/master/session -O /tmp/session
sudo install /tmp/session /usr/local/bin/
sudo chmod +x /usr/local/bin/session

# Test setup
sudo apt install -y screen
sudo apt install -y tree
sudo apt install -y dos2unix

# Python dev env
sudo apt install -y python-pip python-dev build-essential

# More dev setup
sudo apt install -y docker.io

# Perl development
sudo apt install perl-doc
sudo apt install cpanminus perlbrew

# For AVR development on linux
sudo apt-get install gcc-avr binutils-avr avr-libc
sudo apt-get install gdb-avr
sudo apt-get install avrdude


# Lua development
sudo apt install lua5.2

# NodeJS development
sudo apt install NodeJS
sudo apt install npmq

# Shell related
sudo apt install expect
# autoexpect creates expect scripts
sudo apt install expect-dev

# Set up Time on Ubuntu
ntpdate ntp.ubuntu.com

#Golang
sudo apt install golang
mkdir ${HOME}/golang
export GOPATH=${HOME}/golang
echo "export PATH=\$PATH:\$(go env GOPATH)/bin">>${HOME}.bashrc
