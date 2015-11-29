#!/bin/bash
t1=$(date)
(make)||(echo "Started @ $t1"; t2=$(date); echo "Ended   @ $t2")
source ~/.bashrc
export DISABLEBASE=1
export DISABLEPACE=1
export DISABLEUTIL=1
t2=$(date)
echo "Started @ $t1"
echo "Ended   @ $t2"
