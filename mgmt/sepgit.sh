#!/bin/bash



#cluster=$1
#theone=$2
#password=$3
#notAnsible=$4

#dhost=$5

dexx=$(which dexx)

sudo=$(if [ "$(whoami)" != root ]; then echo sudo; else echo ""; fi )

export VISUAL=vim
export EDITOR="$VISUAL"

vimed=$(grep "#vimed" ~/.bashrc); 
if [ "$exped" == "" ]; then sed -i -e "/#vimed/d"  ~/.bashrc; 
	eval "$sudo bash -c \"echo \\\"export VISUAL=vim; export EDITOR=\\\\\\\"\\\\\\\$VISUAL\\\\\\\"; #vimed\\\" >> ~/.bashrc;\""
fi


if [ "$dexx" == "" ]; then
        cd ~;
        eval "$sudo git clone https://github.com/ingted/xlbase.git"
        cd xlbase
        eval "$sudo git checkout --track -b xlbase remotes/origin/backToOrigin"
        source alias/util-disable-status 1 1 1
        ./make.sh 1
        source ~/.bashrc
else
        cd ~/xlbase
        eval "$sudo git reset --hard"
	eval "$sudo git pull"
        source alias/util-disable-status 1 1 1
        ./make.sh 1
        source ~/.bashrc
fi

echo "endsepgitsh"

