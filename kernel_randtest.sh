#!/bin/sh
HOME=/home/vijo
STAGING_KERNEL=${HOME}/projects/kernel/staging/staging
LOGDIR=${HOME}/log
DATESTAMP=$(date +'%y-%m-%d-%H-%M')
(cd ${STAGING_KERNEL} && make clean && mv .config config-${DATESTAMP})
(cd ${STAGING_KERNEL} && ARCH=um make randconfig && cp .config ${LOGDIR}/rand-config-${DATESTAMP} && ARCH=um make -j2 V=1 1>${LOGDIR}/rand-buildout-${DATESTAMP} 2>${LOGDIR}/rand-builderr-${DATESTAMP} && sudo ./linux mem=128M ubda=/home/vijo/projects/kernel/rootfs/CentOS6.x-AMD64-root_fs )
