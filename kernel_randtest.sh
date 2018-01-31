#!/bin/bash

function check_prereqs {
    command -v make 2>/dev/null || { echo >&2 "Need GNU make to continue. Aborting."; exit 1; }
    cmd_make=`command -v make`;
    echo "Using ${cmd_make} for make\n";

    # Requires libc6 libc6-dev

    # Requires gcc-multilib
    # sudo apt-get install gcc-multilib g++-multilib

    # Requires gcc-4.7-plugin-dev for gcc-plugins as in scripts/gcc-plugin.sh
    #sudo apt install gcc-4.7-plugin-dev
    #sudo apt install gcc-5.4-plugin-dev
    #sudo apt install gcc-plugin-dev
    #sudo apt install gcc-5-plugin-dev
    #sudo apt install gcc-5.4-plugin-dev

    # Require libpcap
    #sudo apt install libpcap-dev

    # Require vde XXX Not done now
    # Require rootfs file
    (cd /home/vijo/projects/kernel/rootfs/ && bunzip2 CentOS6.x-AMD64-root_fs.bz2)
}

function setup_env {
    HOME=/home/vijo
    STAGING_KERNEL=${HOME}/projects/kernel/staging/staging
    LOGDIR=${HOME}/log
    DATESTAMP=$(date +'%y-%m-%d-%H-%M')
    ROOTFS=/home/vijo/projects/kernel/rootfs/CentOS6.x-AMD64-root_fs;

    # TODO : set this based on tool chain var
    #export CPP=/usr/bin/cpp-4.7
    #export CC=/usr/bin/gcc-4.7
    #export AR=/usr/bin/ar-4.7
    #export NM=/usr/bin/nm-4.7
    #export GCOV=/usr/bin/gcov-4.7
    #export RANLIB=/usr/bin/gcc-ranlib-4.7
}

function reset_env {
    #unset CPP
    #unset CC
    #unset AR
    #unset NM
    #unset GCOV
    #unset RANLIB
    echo "Test Completed";
}

function clean_kernel_src {
    (cd ${STAGING_KERNEL} && make clean && mv .config config-${DATESTAMP})
}

function build_kernel {
    (cd ${STAGING_KERNEL} && ARCH=um make randconfig && cp .config ${LOGDIR}/rand-config-${DATESTAMP} && ARCH=um make -j2 V=1 1>${LOGDIR}/rand-buildout-${DATESTAMP} 2>${LOGDIR}/rand-builderr-${DATESTAMP} && return 0)
    echo "Build Failed";
    return 1;
}

function run_uml {
    sudo ${STAGING_KERNEL}/linux mem=128M ubda=/home/vijo/projects/kernel/rootfs/CentOS6.x-AMD64-root_fs
    if [ $? -ne 0 ]; then
        echo "UML Failed too boot";
    fi
}

function finishup {
    (cd /home/vijo/projects/kernel/rootfs/ && bzip2 CentOS6.x-AMD64-root_fs)   
    /bin/stty sane
}

check_prereqs;
trap finishup EXIT;
setup_env;
# To start from blank slate ; make distclean; make mrproper
clean_kernel_src;
build_kernel;
run_uml;
reset_env;
finishup;

