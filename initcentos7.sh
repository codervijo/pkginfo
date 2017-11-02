#!/bin/bash

yum group install "Development Tools"
yum install ncurses-devel
yum install hmaccalc zlib-devel binutils-devel elfutils-libelf-devel

yum update && yum upgrade
yum install hmaccalc zlib-devel binutils-devel elfutils-libelf-devel
yum install linux-utils
yum provides bc
yum install base
yum install bc

yum install wget
yum install vim

