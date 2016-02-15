#!/usr/bin/pash
param(
	$role, $ip, $port, $pgdir, $currsm
)

gc "/addfiles/resource_pcmk/$role"|%{
	$str = $_
	
	if(    $str -match "###cfgrole###"){"role=`"$role`" ###cfgrole###"}
	elseif($str -match "###cfgip###"  ){"ip=`"$ip`" ###cfgip###"}
	elseif($str -match "###cfgport###"){"port=`"$port`" ###cfgport###"}
	elseif($str -match "###cfgpgd###" ){"pgdir=`"$pgdir`" ###cfgpgd###"}
	else{$str}
	
}|out-file "/etc/init.d/$role" -encoding ascii -force
chmod +x "/etc/init.d/$role"
([io.fileinfo] "/addfiles/resource_pcmk/xlstatus").copyto("/etc/init.d/xlstatus", $true)
([io.fileinfo] "/addfiles/resource_pcmk/launcher").copyto("/etc/init.d/launcher", $true)
chmod +x "/etc/init.d/xlstatus"
chmod +x "/etc/init.d/launcher"
