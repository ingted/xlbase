#!/usr/bin/pash
param(
	$nodename, $role, $initpath, $ifPurgeExistingData, $ifDebug
)

function in{
	param(
		$testvalue
		, $targetarray
	)
	
	[bool] $(foreach ($i in $targetarray){
		if($i -eq $testvalue){$true}
	})
}
0000
$purge = {
	param(
		$toPurge, $confirm
	)
	if($confirm) {
                $path = [io.directoryinfo] $toPurge
                $path.delete($true)
                $path.create()
        }
}

123
$debug_cnt = {
	if($ifDebug){write-host ("item #:" + [int](dir $initpath).count)}
}
234
$groles = @{gtm="gtm"; gtmsby="gtm"; gtmprx="gtm_proxy"}
$droles = @{coor="coordinator"; dn="datanode"}
567
$ip = [io.directoryinfo] $initpath
if(!$ip.exists){$ip.create()}

$r_in  = in $role $groles.keys
$r_in2 = in $role $droles.keys
& $debug_cnt
if ($r_in){
	& $purge $initpath $ifPurgeExistingData
	& $debug_cnt
	write-host $("initgtm -Z " + $groles[$role] + " -D $initpath")
	initgtm -Z $groles[$role] -D $initpath
} elseif ($r_in2){
	& $purge $initpath $ifPurgeExistingData
	& $debug_cnt
	write-host "initdb --nodename $nodename -D $initpath"
	initdb --nodename $nodename -D $initpath
} else {
	"wrong data specified to init!"
}
