#!/usr/bin/pash
param(
	$cluster, $dexxpath, $dexxcpath
)


. cluster-gen-cluster.ps1 $cluster $dexxpath

$dhosts = $htHosts|?{$_.role -eq "docker"}|%{$_.hostname}


$dhosts | %{
	$dhost = $_
	$chosts =  $htHosts|?{$_.reside -eq $dhost}|%{$_.hostname}
	$chosts 

	dexx -n $cluster $dhost "cd $dexxcpath; export PATH=`$PATH:`$(pwd); don3 $chosts"
	
}

