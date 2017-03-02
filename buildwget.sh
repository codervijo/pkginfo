#!/bin/bash

# Things to do to build wget - some of it is one time setup
WGETDIR=?$1
# TODO check if it is Linux. Build from source works best in Linux
echo "Starting wget build from $WGETDIR"

# If it is first time build on this set up/docker/Ubuntu installation
# sudo apt install -y autoconf automake
# sudo apt install -y autopoint texinfo flex
# sudo apt install -y gperf
# sudo apt install -y gnutls
# sudo apt install -y libssl-dev
# # To build docs
# sudo apt-get install -y texlive

# TODO Dont run bootstrap if it was run before
if [ ! -f $WGETDIR/configure ];
then
	(cd $WGETDIR && ./bootstrap)
	if [ $? -eq 0 ];
	then
        	# Don't run configure if it successfully ran earlier
		(cd $WGETDIR && ./configure --with-ssl=openssl --with-openssl)
		if [ $? -eq 0 ];
		then
			(cd $WGETDIR && make)
		fi
	fi
else
	if [ ! -f $WGETDIR/Makefile ];
	then
		(cd $WGETDIR && ./configure --with-ssl=openssl --with-openssl)
		if [ $? -eq 0 ];
		then
			(cd $WGETDIR && make)
		else
			echo "Failed to configure"
		fi
	else
		(cd $WGETDIR && make)
		if [ $? -eq 0 ];
		then
			echo "Failed to run make"
		fi
	fi	
fi

# If it all passed, try tests
(cd $WGETDIR && make check)


# TODO Check if $WGETDIR/src/wget was made.

# Do make pdf to create PDF help doc file
(cd $WGETDIR && make pdf)
if [ -f $WGETDIR/doc/wget.pdf ];
then
	echo "Created wget.pdf"
	evince $WGETDIR/doc/wget.pdf
else
	echo "Failed to create PDF documentation"
	exit 1
fi

exit 0

