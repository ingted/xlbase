#!/usr/bin/pash
param(
	$hb64
)
#sed -e s/$1/$(hostname)/g /etc/hosts > /etc/ttc

#cp /etc/hosts > /etc/hosts.bak
#echo "$1" > /etc/hosts.tmp

#cp /etc/hosts.tmp /etc/hosts -f

$hd = ./decode-mgmt-msg.ps1 $hb64
$hd | out-file /etc/hosts.tmp -Encoding ascii
