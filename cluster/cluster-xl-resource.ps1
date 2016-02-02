#!/usr/bin/pash
param(
	$role, $ip, $port, $pgdir
)

gc "/addfiles/resource_pcmk/$role"|%{
	$str = $_
	
	if($_ -match "###cfgrole###"){"role=`"$role`""}
	elseif($_ -match "###cfgip###"){"ip=`"$ip`""}
	elseif($_ -match "###cfgport###"){"port=`"$port`""}
	elseif($_ -match "###cfgpgd###"){"pgdir=`"$pgdir`""}
	else{$str}
	
}|out-file "/etc/init.d/$role" -encoding ascii -force
