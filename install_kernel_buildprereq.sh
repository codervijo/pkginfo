#!/bin/bash

# Shell script to install all the pre-requisites to run
# linux kernel builds

sudo apt-get install -y make build-essential
sudo apt-get install -y git
sudo apt-get install -y pkg-config

# For make gconfig
sudo apt-get install -y libgtk2.0-dev libglib2.0-dev libglade2-dev

# For cscope
sudo apt-get install -y cscope
