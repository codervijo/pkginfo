#!/bin/bash

SDSRCDIR:${SDSRCDIR:=$PWD}
echo "Starting systemd build from ${SDSRCDIR}"

type meson
if [ $? -ne 0 ]; then
	sudo apt install meson
fi
type ninja
if [ $? -ne 0 ]; then
	sudo apt install ninja
fi
(cd ${SDSRCDIR} && ./configure && make)
