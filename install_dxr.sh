#!/bin/bash 
apt install -y make build-essential 
apt install -y libclang-dev llvm-dev pkg-config npm 
#apt install -y openjdk-7-jdk 
#apt install -y elasticsearch 
apt install -y nodejs 
  
# Java 
apt-get install software-properties-common 
add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" 
add-get install openjdk-7-jdk 
 
 
# Elastic search 
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - 
apt-get install apt-transport-https 
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list 
 
apt-get update && apt-get install elasticsearch
