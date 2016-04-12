#!/usr/bin/pash
param(
	$cluster, $dexxpath, $doact, $hostname
)


. cluster-gen-cluster.ps1 $cluster $dexxpath

$authnode = $htHosts |?{$_.role -ne "docker"}| %{$_.hostname}

$ofs = " "
#pcs cluster auth "$authnode"
$authnode | %{
	bash -c "pcs cluster auth $_"
}


