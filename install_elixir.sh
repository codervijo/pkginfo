#!/bin/bash 
 
apt-get install python3 
if [ $? -ne 0 ]; then echo "Failed to install python3"; fi 
apt-get install python3-pip 
if [ $? -ne 0 ]; then echo "Failed to install python3-pip"; fi 
apt-get install exuberant-ctags 
if [ $? -ne 0 ]; then echo "Failed to install Exuberant ctags"; fi 
apt-get install perl 
if [ $? -ne 0 ]; then echo "Failed to install perl"; fi 
apt-get install jinja2 pygments 
if [ $? -ne 0 ]; then echo "Failed to install jinga2"; fi 
pip install jinja2 pygments 
if [ $? -ne 0 ]; then echo "Failed to install jinga2-python"; fi 
apt-get install libdb-dev 
if [ $? -ne 0 ]; then echo "Failed to install Berkeley DB"; fi 
pip3 install bsddb3 
if [ $? -ne 0 ]; then echo "Failed to install bsddb3"; fi 
 
git clone https://github.com/bootlin/elixir.git
