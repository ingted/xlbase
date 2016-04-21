#!/usr/bin/pash
param(
	$cluster, $dexxpath, $doact, $hostname
)

. cluster-gen-cluster.ps1 $cluster $dexxpath

if(($htHosts|?{$_.hostname -eq $hostname}).role -eq "coor"){$port = 40001} else {$port = 10002}
$htHosts|?{$_.masterslave -eq "m" -and $_.role -notmatch "gtm"}|%{
    if($_.hostname -eq $hostname){
        $act = "alter"
    } else {
        $act = "create"
    }
    if($doact -eq $act){
        if($_.role -eq "coor"){
            psql -p $port -c $($act + " node coor" + $_.nodeid + " with(TYPE='coordinator',HOST='" + $_.ip + "',PORT=40001);")


        } else {
            psql -p $port -c $($act + " node dn" + $_.nodeid + " with(TYPE='datanode',HOST='" + $_.ip + "',PORT=10002);")
        }
        psql -p $port -c $("select pgxc_pool_reload();")
    }
}








