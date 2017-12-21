#!/bin/bash

# Things to do to build wget - some of it is one time setup
KEXECTOOLSDIR=${KEXECTOOLSDIR:=$PWD}
# TODO check if it is Linux. Build from source works best in Linux
echo "Starting kexectools build from $KEXECTOOLSDIR"

# TODO apt install only if it is first time
# If it is first time build on this set up/docker/Ubuntu installation
sudo apt install -y autoconf automake
sudo apt install -y autoheader aclocal

# Run each step if it was not run successfully
if [ ! -f $KEXECTOOLSDIR/configure ];
then
	(cd $KEXECTOOLSDIR && ./bootstrap)
	if [ $? -ne 0 ];
	then
		echo "Failed to complete bootstrap";
		exit -1;
	fi
fi

if [ ! -f $KEXECTOOLSDIR/Makefile ];
then
    # Don't run configure if it successfully ran earlier
	(cd $KEXECTOOLSDIR && ./configure)
	if [ $? -ne 0 ];
	then
		echo "Failed to complete configure step";
		exit -1;
	fi
fi

(cd $KEXECTOOLSDIR && make)
if [ $? -ne 0 ];
then
	echo "Failed to run make on wget";
	exit -1;
fi


exit 0

