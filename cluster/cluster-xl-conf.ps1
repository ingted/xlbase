#!/usr/bin/pash
param(
	$nodename, $role, $initpath
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

$groles = @{gtm="gtm"; gtmsby="gtm"; gtmprx="gtm_proxy"}
$droles = @{coor="coordinator"; dn="coordinator"}

$r_in  = in $role $groles.keys
$r_in2 = in $role $droles.keys
if ($r_in){
	initgtm -Z $groles[$role] -D $initpath
} elseif ($r_in2){
	initdb --nodename $nodename -D $initpath
} else {
	"wrong role specified!"
}
