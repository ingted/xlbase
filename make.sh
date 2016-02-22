#!/bin/bash
t1=$(date)
apt-get -y install software-properties-common automake autogen autoconf zfs-fuse
#add-apt-repository -y ppa:zfs-native/stable
#apt-get -y update
#apt-get -y install -y ubuntu-zfs
modprobe zfs

(make)||(echo "Started @ $t1"; t2=$(date); echo "Ended   @ $t2")
source ~/.bashrc



export DISABLEBASE=1
export DISABLEPACE=1
export DISABLEUTIL=1
t2=$(date)
echo "Started @ $t1"
echo "Ended   @ $t2"
