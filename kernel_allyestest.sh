#!/bin/sh
STAGING_KERNEL=~vijo/projects/kernel/staging/staging
LOGDIR=~vijo
DATESTAMP=$(date +'%y-%m-%d')
(cd ${STAGING_KERNEL} && make clean && mv .config config-${DATESTAMP})
(cd ${STAGING_KERNEL} && make allyesconfig && make -j2 V=1 1>${LOGDIR}/rand-buildout-${DATESTAMP} 2>${LOGDIR}/rand-builderr-${DATESTAMP})
