#!/usr/bin/pash
param(
	
)
$hb64 = "$args".replace(" ", "")

$hd = . decode-mgmt-msg.ps1 $hb64
if($hd.gettype().name -eq "string"){
	$out = $hd 
} else {
	$out = $hd[0]
}

$out | out-file /etc/hosts.tmp -Encoding ascii
#write-host $out
cp /etc/hosts.tmp /etc/hosts
