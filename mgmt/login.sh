#!/bin/bash



echo -n Set Password:
read -s password


if [ "$password" == "" ]; then
        password="/'],lp123"
fi

hosts=$(./mgmt-xl-get-host-by-role)
for host in $hosts; do

	cip=$(./mgmt-xl-get-ip $host)
	
	./login.expect $cip $password
