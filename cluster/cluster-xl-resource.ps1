#!/usr/bin/pash
param(
	$role, $ip, $port, $pgdir
)

gc "/addfiles/resource_pcmk/$role"|%{
	$str = $_
	
	if($str -match "###cfgrole###"){"role=`"$role`""}
	elseif($str -match "###cfgip###"){"ip=`"$ip`""}
	elseif($str -match "###cfgport###"){"port=`"$port`""}
	elseif($str -match "###cfgpgd###"){"pgdir=`"$pgdir`""}
	else{$str}
	
}|out-file "/etc/init.d/$role" -encoding ascii -force
