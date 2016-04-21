#!/usr/bin/pash
param(
	$cluster, $dexxpath, $doit, $specifiedhostname
)

. cluster-gen-cluster.ps1 $cluster $dexxpath




$domainip = $htHosts | ?{$_.hostname -eq "gtm"} | %{$_.ip.substring(0, $_.ip.LastIndexOf(".") + 1)}

#($htHosts|?{$_.masterslave -eq "m"}|?{if("$hostname" -ne ""){$_.hostname -eq $hostname}else{$true}}).count

$htHosts|?{$_.masterslave -eq "m"}|?{if("$specifiedhostname" -ne ""){$_.hostname -eq $hostname}else{$true}}|%{
    $vipnm = $_.role + $_.nodeid
    $vipint = $(if($_.role -eq "gtm"){1}else{$_.nodeid})
    $viplast = $(if($_.role -eq "gtm"){"252"}else{[int] $_.ip.Substring($_.ip.LastIndexOf(".") + 1) + 6})
    $master = $_
    $slave = $htHosts|?{($_.masterslave -eq "s") -and (($_.role -eq $master.role) -or (($master.role -eq "gtm") -and ($_.role -eq "gtmsby"))) -and ($_.nodeid -eq $master.nodeid)}
    $pcsresource = ""
    $pcsr = pcs resource
    $pcsr|%{$pcsresource += $_ + "`n"}
    "--------------"
    $pcsresource
    #if($pcsresource -match ("vip-" + $vipnm)){"yes!!!"}
    $cmd = $($(if($pcsresource -match ("vip-" + $vipnm)){
	  "pcs resource delete vip-" + $vipnm + "`n" +
	  "crm resource cleanup vip-" + $vipnm + "`n"} else {""}) +
	  "sleep 5`n" +
	  "pcs resource create vip-" + $vipnm + " IPaddr2 \`n" +
          "ip=`"" + $domainip + $viplast + "`" \`n" +
          "nic=`"eth" + $vipint + ":1`" \`n" +
          "cidr_netmask=`"24`" \`n" +
          "op start timeout=`"60s`" interval=`"0s`" on-fail=`"restart`" \`n" +
          "op monitor timeout=`"60s`" interval=`"10s`" on-fail=`"restart`" \`n" +
          "op stop timeout=`"60s`" interval=`"0s`" on-fail=`"block`"`n" +
	  "pcs constraint location vip-" + $vipnm + " prefers " + $master.hostname + "=200`n" +
	  "pcs constraint location vip-" + $vipnm + " prefers " + $slave.hostname + "=0`n"
)

    $cmd
    if($doit){bash -c $cmd}
}




pcs resource


