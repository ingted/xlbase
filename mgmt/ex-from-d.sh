#!/bin/bash

host=$1
cmd=$2
timeout=$3
usr=$4

if [ "$usr" != "" ]; then 
	ssh $usr@$host touch ~/.hushlogin
else
	ssh $host touch ~/.hushlogin		
fi

./ex-from-d.expect "$host" "$cmd" $timeout $usr
