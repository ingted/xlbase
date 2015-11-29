#!/bin/bash

#sed -e s/$1/$(hostname)/g /etc/hosts > /etc/ttc

cp /etc/hosts > /etc/hosts.bak
echo "$1" > /etc/hosts.tmp

cp /etc/hosts.tmp /etc/hosts -f

