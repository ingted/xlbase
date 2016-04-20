#!/usr/bin/pash
param(
	$cluster, $dexxpath, $doact, $hostname
)

. cluster-gen-cluster.ps1 $cluster $dexxpath




$domainip = $htHosts | ?{$_.hostname -eq "gtm"} | %{$_.ip.substring(0, $_.ip.LastIndexOf(".") + 1)}

($htHosts|?{$_.masterslave -eq "m"})[0]|%{
    $vipnm = $_.role + $_.nodeid
    $vipint = $(if($_.role -eq "gtm"){1}else{$_.nodeid})
    $viplast = $(if($_.role -eq "gtm"){"252"}else{[int] $_.ip.Substring($_.ip.LastIndexOf(".") + 1) + 6})

    $cmd = $("pcs resource create vip-" + $vipnm + " IPaddr2 \`n" +
          "ip=`"" + $domainip + $viplast + "`" \`n" +
          "nic=`"eth" + $vipint + ":1`" \`n" +
          "cidr_netmask=`"24`" \`n" +
          "op start timeout=`"60s`" interval=`"0s`" on-fail=`"restart`" \`n" +
          "op monitor timeout=`"60s`" interval=`"10s`" on-fail=`"restart`" \`n" +
          "op stop timeout=`"60s`" interval=`"0s`" on-fail=`"block`"")

    $cmd
    bash -c $cmd
}







