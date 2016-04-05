#!/usr/bin/pash
param(
	$setuser, $nodename, $role, $initpath, $ifPurgeExistingData, $ifDebug, $clusternodename
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

$debug_cnt = {
	if($ifDebug){write-host ("item #:" + [int](dir $initpath).count)}
}
$groles = @{gtm="gtm"; gtmsby="gtm"; gtmprx="gtm_proxy"}
$droles = @{coor="coordinator"; dn="datanode"}
$ip = [io.directoryinfo] $initpath
if(!$ip.exists){$ip.create()}

$r_in  = in $role $groles.keys
$r_in2 = in $role $droles.keys
& $debug_cnt
if ($r_in){
	& $purge $initpath $ifPurgeExistingData
	& $debug_cnt
	write-host $("initgtm -Z " + $groles[$role] + " -D $initpath")
	chown "$setuser:$setuser" "$initpath" -Rf
	cd $initpath
	setuser $setuser initgtm -Z $groles[$role] -D $initpath
} elseif ($r_in2){
	& $purge $initpath $ifPurgeExistingData
	& $debug_cnt
	write-host "initdb --nodename $clusternodename -D $initpath"
	chown "$setuser:$setuser" "$initpath" -Rf
	cd $initpath
	setuser $setuser initdb --nodename $clusternodename -D $initpath
} else {
	"wrong data specified to init!"
}
