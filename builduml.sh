#!/bin/sh
HOME=/home/vijo
SRCDIR=${HOME}/projects/kernel/staging/staging
LOGDIR=${HOME}/log
DATESTAMP=$(date +'%y-%m-%d-%H-%M')
(cd ${SRCDIR} && make clean && mv .config config-${DATESTAMP} && make defconfig ARCH=um)
(cd ${SRCDIR} && make oldconfig ARCH=um && ARCH=um make -j2 V=1 1>${LOGDIR}/uml-buildout-${DATESTAMP} 2>${LOGDIR}/uml-builderr-${DATESTAMP})

echo "Booting new UML Kernel"
(cd /home/vijo/projects/kernel/rootfs/ && bunzip2 CentOS6.x-AMD64-root_fs.bz2)
(cd ${SRCDIR} && sudo ./linux mem=128M ubda=/home/vijo/projects/kernel/rootfs/CentOS6.x-AMD64-root_fs)
