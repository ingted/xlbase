#!/bin/bash
t1=$(date)

if [ "$1" != 1 ]; then
        notAnsible=1
else
        notAnsible=0
fi

if [ "$2" != 1 ]; then
        notSkip=1
else
        notSkip=0
fi

sudo=$(if [ "$(whoami)" != root ]; then echo sudo; else echo ""; fi )
if [ $notAnsible == 1 ] && [ $notSkip == 1 ]; then
	eval "$sudo apt-get -y install software-properties-common automake autogen autoconf zfs-fuse"
	#add-apt-repository -y ppa:zfs-native/stable
	#apt-get -y update
	#apt-get -y install -y ubuntu-zfs
	eval "$sudo modprobe zfs"
fi


(make)||(echo "Started @ $t1"; t2=$(date); echo "Ended   @ $t2")
source ~/.bashrc



export DISABLEBASE=1
export DISABLEPACE=1
export DISABLEUTIL=1
t2=$(date)
echo "Started @ $t1"
echo "Ended   @ $t2"
