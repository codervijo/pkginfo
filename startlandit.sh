#!/bin/bash

LANDDIR=${LANDDIR:=$PWD}
# TODO check if it is Linux.
echo "Starting LandIt Rails App from $LANDDIR"

(cd $LANDDIR && rails server -d -p 3000 &)

exit 0
