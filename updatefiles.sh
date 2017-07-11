#!/bin/bash

#Expect absolute path, hard coded path & filenames, separated by :
# Example
#SRCDIR="/home/vijo/blah";
SRCDIR=
# Example
#SRCFILES="/a:/b:/c:/d:/e:/f/g:/f/h:/f/i";
SRCFILES=
# Example
#DSTDIR="/home/vijo/bin:/home/vijo/lib";
DSTDIR=
DSTFILES="";

TOPDIR=$PWD
# If argument is "build", combine this and the files into one script
if [ x"$1" == x"build" ];
then
	TMPDIR=`/bin/mktemp -d /tmp/selftar.XXXXXX`
	/bin/cp $0 ${TMPDIR}/installscript.sh
        # echo "\n">>${TMPDIR}/installscript.sh
	(cd ${TMPDIR} && /bin/tar cf mt.tar installscript.sh) 
	IFS=':'
        for src in ${SRCFILES}
	do
		sfile=${SRCDIR}/${src};
                /bin/tar --append --file=${TMPDIR}/mt.tar ${sfile} 2>/dev/null
	done
	/bin/gzip ${TMPDIR}/mt.tar
	if [ $? -ne 0 ];
	then
		echo "Failed to compress files";
		exit -1;
	fi
	/bin/cat ${TMPDIR}/mt.tar.gz>>${TMPDIR}/installscript.sh
        cp ${TMPDIR}/installscript.sh ${PWD}
fi
 
# If argument is "run", run the extractor and related scripts
if [ x"$1" == x"run" ];
then
        # TODO check if operations are permitted
	TMPDIR=`/bin/mktemp -d /tmp/selfextract.XXXXXX`
	ARCHIVE=`/usr/bin/awk '/^__INSTALLER_BELOW__/ {print NR + 2; exit 0; }' $0`
	/usr/bin/tail -n+${ARCHIVE} $0 | /bin/cat >${TMPDIR}/narch.tar.gz
	(cd ${TMPDIR} && tar zxf narch.tar.gz -C . --strip-components=5)
	#(cd ${TMPDIR} &
        # Next move files
        # Copy old files to .orig for backup
	if [ $? -ne 0 ]; then
		echo "Failed to untar files properly";
		exit;
	fi
        TSTAMP=$(date +%Y%b%d%H%M)
        BACKUPDIR=orig.${TSTAMP}
	(cd ${TMPDIR} && mkdir ${BACKUPDIR})
        # Keep a backup copy in this directory
        IFS=':'
        for src in ${SRCFILES}
	do
		for dir in ${DSTDIR}
		do
			if [ -f "${dir}"/"${src}" ]; then
				sfile=${dir}/${src};
				cp ${sfile} ${TMPDIR}/${BACKUPDIR}
			fi
		done
	done
        # Keep a backup copy in base directory of each file
        IFS=':'
        for src in ${SRCFILES}
	do
		for dir in ${DSTDIR}
		do
			if [ -f "${dir}"/"${src}" ]; then
				(cd ${dir} && cp ./${src} "./${src}.orig.${TSTAMP}";)
                                # Finally copy new file to the location
				(cd ${TMPDIR} && cp gpio/${src} ${dir})
			fi
		done
	done
fi

exit 0;

__INSTALLER_BELOW__

