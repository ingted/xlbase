#!/bin/bash



cluster=$1
theone=$2
password=$3
notAnsible=$4

dhost=$5

dexx=$(which dexx)

if [ "$dexx" == "" ]; then
	cd ~;
	git clone https://github.com/ingted/xlbase.git
	cd xlbase
	git checkout --track -b xlbase remotes/origin/backToOrigin
	source alias/util-disable-status 1 1 1
	./make.sh 1
	source ~/.bashrc
else
	cd ~/xlbase
	git reset --hard
	git pull
	source alias/util-disable-status 1 1 1
        ./make.sh 1
	source ~/.bashrc
fi

echo "endsepgitsh"
