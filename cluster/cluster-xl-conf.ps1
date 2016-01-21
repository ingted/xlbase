#!/usr/bin/pash
param(
	$confpath
)

$db64 = "$args".replace(" ", "")
$dd = . decode-mgmt-msg.ps1 $db64
write-host "decoded: `n$dd"
#if($hd.gettype().name -eq "string"){
#       $out = $dd
#} else {
#       $out = $dd[0]
#}
$configstr = ""
$dd | %{
        $d = $_.split("`n")
	$d | ?{
		$_ -ne ""
	} | %{
		$configstr += "`n" + $_
	}
}
$cp = [io.fileinfo] $confpath
if(!$cp.Directory.exists){$cp.Directory.create()}
$configstr | out-file $confpath -Encoding ascii -Force
