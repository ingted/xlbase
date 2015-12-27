#!/bin/bash

dhost="192.168.123.107"
chost="192.168.123.103"
password="/'],lp123"
sleep=10
ssh-keygen -R $chost
ssh-keyscan -H $chost >> ~/.ssh/known_hosts
VAR=$(ssh $dhost << EOF
	expect -dc "
	    	spawn ssh-copy-id $chost
		exec sleep $sleep
	    	expect {
			\"password:\" {
				send \"$password\\n\"
			}
			\"(yes/no)?\" {
				send \"yes\\n\"
			}
			\"already exist\" {
			}
		}
		expect {
			*{}
		}
	    	exit
	"
EOF
)

echo "==============="
echo "$VAR"
