#!/usr/bin/pash
param(
	$nodename, $role, $initpath, $ifPurgeExiistingData, $ifDebug
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

$groles = @{gtm="gtm"; gtmsby="gtm"; gtmprx="gtm_proxy"}
$droles = @{coor="coordinator"; dn="coordinator"}

$r_in  = in $role $groles.keys
$r_in2 = in $role $droles.keys
if($ifDebug){write-host ("item #:" + (dir $initpath).count)}
if ($r_in){
	& $purge $initpath $ifPurgeExistingData
	if($ifDebug){write-host ("item #:" + (dir $initpath).count)}
	write-host $("initgtm -Z " + $groles[$role] + " -D $initpath")
	initgtm -Z $groles[$role] -D $initpath
} elseif ($r_in2){
	& $purge $initpath $ifPurgeExistingData
	if($ifDebug){write-host ("item #:" + (dir $initpath).count)}
	write-host "initdb --nodename $nodename -D $initpath"
	initdb --nodename $nodename -D $initpath
} else {
	"wrong data specified to init!"
}
