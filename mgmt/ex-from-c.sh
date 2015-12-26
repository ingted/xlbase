#!/bin/bash

chost=$1
cluster=$2
cmd=$3
timeout=$4
usr=$5

host=$(./mgmt-xl-get-base $cluster 2 $chost "\$1")

if [ "$usr" != "" ]; then 
	ssh $usr@$host touch ~/.hushlogin
else
	ssh $host touch ~/.hushlogin		
fi

./ex-from-d.expect "$host" "$cmd" $timeout $usr
