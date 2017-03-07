#!/bin/bash

# Start a Qemu instance

sudo apt-get install -y qemu-kvm qemu virt-manager 
sudo apt-get install -y virt-viewer libvirt-bin

PKGS=${HOME}/pkgs/
IMGFILE=${PKGS}/ubuntu.img
QCOWFILE=${PKGS}/ubuntu.qcow
ISOFILE=${HOME}/pkgs/ubuntu-16.04.2-server-amd64.iso

if [ -e ${PKGS} -a -e ${IMGFILE} ];
then
	echo "Not creating ubuntu img";
else
	/usr/bin/qemu-img create ${IMGFILE} 20G
	if [ $? -ne 0 ];
	then
		echo "Failed to create ${IMGFILE}";
		rm -f ${IMGFILE}
		exit -1;
	fi
fi

if [ -e ${PKGS} -a -e ${QCOWFILE} ];
then
	echo "Not creating ubuntu qcow";
else
	/usr/bin/qemu-img create -f qcow2 ${QCOWFILE} 20G
	if [ $? -ne 0 ];
	then
		echo "Failed to create qcow ${QCOWFILE}";
		rm -f ${QCOWFILE} ${IMGFILE}
		exit -1;
	fi
fi

/usr/bin/qemu-system-x86_64 -hda ${IMGFILE} -boot d -cdrom ${ISOFILE}  -m 1024
