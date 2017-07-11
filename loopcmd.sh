 #!/bin/bash

 # Usage : set MAXCOUNT env variable
 # Or use first argument for MAXCOUNT

 MAXCOUNT=${MAXCOUNT:=$1}
 i=0
 # TODO add option to suppress message from command
 while [ $i -lt $MAXCOUNT ]; do
 	# TODO make this into any given command
 	make check -j 4;
 	if [ $? -ne 0 ]; then
 		echo "Test failed";
 		exit -1;
 	fi
 	sleep 10;
 	i=$((i+1));
 done
 echo "All the tests passed in $MAXCOUNT loops";