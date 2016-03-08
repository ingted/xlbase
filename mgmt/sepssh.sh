#!/bin/bash



cluster=$1
theone=$2
password=$3
notAnsible=$4

dhost=$5


if [ "$notAnsible" == 0 ]; then
	if [ "$password" == "" ]; then
		password="/'],lp123"
	fi
fi

cd ~/xlbase/mgmt

./mgmt-init-set-xl-config $cluster

#echo ./mgmt-xl-get-ip $dhost $cluster
dip=$(./mgmt-xl-get-ip $dhost $cluster)
#if [ "$dip" != "" ]; then

echo "processing... $dip: $dhost"
echo 1=========================================
#fi
#if [ $notAnsible == 1 ]; then
        ssh-keygen -R $dip
        ssh-keygen -R $dhost
#fi
echo 2=========================================
#if [ $notAnsible == 1 ]; then
        ssh-keyscan -H $dip >> ~/.ssh/known_hosts
        ssh-keyscan -H $dhost >> ~/.ssh/known_hosts
#fi
echo 3=========================================
#if [ $notAnsible == 1 ]; then
        if [ ! -e ~/.ssh/id_rsa ] || [ ! -e ~/.ssh/id_rsa.pub ]; then
                echo 3.1=======================================
                ./genkey.expect
        fi
        ./login.expect $dip "$password" #> /dev/null
#fi

echo "endsepsshsh"
