#!/bin/bash

o=$(svcs)

g1=$(echo $o|grep \ pcsd\ )
if [ "$g1" != "" ]; then service pcsd restart; fi

g2=$(echo $o|grep \ corosync\ )
if [ "$g2" != "" ]; then service corosync restart; fi

g3=$(echo $o|grep \ pacemaker\ )
if [ "$g1" != "" ]; then service pacemaker restart; fi
