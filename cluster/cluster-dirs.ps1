#!/usr/bin/pash
param(
	
)
$db64 = "$args".replace(" ", "")

$dd = . decode-mgmt-msg.ps1 $db64
#if($hd.gettype().name -eq "string"){
#	$out = $dd 
#} else {
#	$out = $dd[0]
#}

$dd | %{
	$d = $_.split("`n")
	$d | %{
		$fi = New-Item -ItemType directory -Path $_
		if($fi.Exists){
			write-host "$_`: create successfully!"
		}
	}
}
