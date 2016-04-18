param(
	$cluster, $dexxpath, $hostname, $add, $24
)
if("$cluster" -eq ""){
	$cluster = "ansible3"
}
if($dexxpath -eq ""){
	$dexxpath = "/root/pcmk/alias"
}
if($add -eq ""){
	$add = $false
}
if($24 -eq ""){
	$24 = $false
}
$netmask = 24
$allroles = gc "$dexxpath/dexxhostroles"
#$allroles = gc "c:\dexxhostroles"
$roles = $allroles | %{[regex]::Replace($_, "\s", "%%%")} | %{$s = $_.split([string[]]"%%%", [System.StringSplitOptions]::RemoveEmptyEntries);  if ($s[-2] -eq $cluster){,@($s)}}

#$allhosts = gc "c:\dexxhosts"
$allhosts = gc "$dexxpath/dexxhosts"
$hosts = $allhosts | %{[regex]::Replace($_, "\s", "%%%")} | %{$s = $_.split([string[]]"%%%", [System.StringSplitOptions]::RemoveEmptyEntries);  if ($s[-1] -eq $cluster){,@($s)}}

$htHosts = @()

$hosts | %{
    $host_ = $_
    if($host_.count -eq 1){
        $host_ = $host_[0]
    }
    $role = $roles | ?{
        $(
            if($_.count -ne 1){$_}
            else{$_[0][0]}
        ) -eq $host_[1]
    }
    if($role.count -eq 1){
        $role = $role[0]
    }
    $htHosts += @{
        ip = $host_[0];
        hostname = $host_[1];
        reside = $host_[3];
        role = $role[2];
        nodeid = $role[1];
        masterslave = $role[4];
        ifContainer = $(if($host_[2] -eq "c"){$true} else{$false})
    }
}
function in{
        param(
                $testvalue
                , $targetarray
        )

        [bool] $(foreach ($i in $targetarray){
                if($i -eq $testvalue){$true}
        })
}

$interfaces = @{ctodn = "eth1"; togtm = "eth2"; toclient = "eth0"<# vip_coor #>; tovolt = "eth4"; topregcd = "eth5"; 
    tonextgcd = "eth5"; dc2gtmprx = "eth6"; toother = "eth3"}


$nodescount = ($htHosts.count + 10) / 7
$looplength = $nodescount - 2
$domainip = $htHosts | ?{$_.hostname -eq "gtm"} | %{$_.ip.substring(0, $_.ip.LastIndexOf(".") + 1)}


if($host.Version -ne ""){
    function bash {param($c) $c}
    function ip {param($c) 
        "$($domainip)0/24 dev eth0  proto kernel  scope link  src 10.128.112.94    "
        "$($domainip)0/24 dev eth3  scope link  metric 100                         "
        "$($domainip)1 dev eth5  scope link  metric 20                             "
        "$($domainip)2 dev eth5  scope link                                        "

    }
}

$bs1ton = $htHosts|?{($_.role -eq "docker")}|%{$_.hostname}
$ghostht = $htHosts|?{(in $_.role @("gtmprx")) -and (($_.masterslave -eq "m") -or ($_.role -eq "gtmsby"))}
$ghost = $ghostht|%{$_.hostname}
$cd = $htHosts|?{($_.role -eq "coor") -or ($_.role -eq "dn")}|%{$_.hostname}
$coor = $htHosts|?{($_.role -eq "coor")}|%{$_.hostname}
if("$hostname" -eq ""){
	$hostname = hostname
}


<#
1..6 | %{
    "ip route delete $domainip" + "0/24 dev eth$_"
    bash -c $("ip route delete $domainip" + "0/24 dev eth$_")
}
#>

$iproute = ip route
$iproute | ?{
    $_ -match ("^$domainip".Replace(".", "\."))
} | %{
    "ip route delete $_"
    bash -c $("ip route delete $_")
}

if ($24 -eq 1){
	if($(in $hostname $ghost)){ 
	    bash -c $("ip route add $($domainip)0/$($netmask) dev $($interfaces.toother) metric 200")
	}
} else {
	if($(in $hostname $ghost)){ 
		1..6 | %{
			"ip route add $($domainip)0/$($netmask) dev eth$_ metric 200 src $(($ghostht.nodeid - 1) * 10 + $_)"
			bash -c $("ip route add $($domainip)0/$($netmask) dev eth$_ metric 200 src $(($ghostht.nodeid - 1) * 10 + $_)")
		}
	}

}
if ($add){

	if($(in $hostname $ghost)){ 
	    0..($looplength - 1) | %{
	        "ip route add $domainip" + [string] ($_ * 10 + 9) + " dev $($interfaces.ctodn) metric 20"
	        bash -c $("ip route add $domainip" + [string] ($_ * 10 + 9) + " dev $($interfaces.ctodn) metric 20")
	        bash -c $("ip route add $domainip" + [string] ($_ * 10 + 3) + " dev $($interfaces.ctodn) metric 20")
	    }
	    0..1 | %{
	        "ip route add $domainip" + [string] (250 + $_) + " dev $($interfaces.togtm) metric 20"
	        bash -c $("ip route add $domainip" + [string] (250 + $_) + " dev $($interfaces.togtm) metric 20")
	    }
	}
	if($(in $hostname $ghost)){
	    $curnodeid = ($htHosts | ?{($_.hostname -eq $hostname) -and ($_.masterslave -EQ "m")}).nodeid
	    $curnode_master_c = $htHosts | ?{($_.masterslave -EQ "m") -AND ($_.nodeid -EQ $curnodeid)}
	    $curnode_slave_c = $htHosts | ?{($_.masterslave -EQ "s") -AND ($_.reside -EQ $curnode_master_c[0].reside)}
	    $nxtnode_slave_c = $htHosts | ?{($_.masterslave -EQ "s") -AND ($_.nodeid -EQ $curnodeid)}
	
	    $prenode_master_c = $htHosts | ?{($_.masterslave -EQ "m") -AND ($_.nodeid -EQ $curnode_slave_c[0].nodeid)}
	    "pre--------------------------------------------------"
	    $prenode_master_c | %{
	        "ip route add $($_.ip)/32 dev $($interfaces.topregcd) metric 50"
	        bash -c $("ip route add $($_.ip)/32 dev $($interfaces.topregcd) metric 50")
	    }
	    "nxt--------------------------------------------------"
	    $nxtnode_slave_c | %{
	        "ip route add $($_.ip)/32 dev $($interfaces.tonextgcd) metric 50"
	        bash -c $("ip route add $($_.ip)/32 dev $($interfaces.tonextgcd) metric 50")
	    }
	    "ixl--------------------------------------------------"
	    "ip route add $domainip" + "$(($curnode_master_c[0].nodeid - 1) * 10 + 7)/32 dev $($interfaces.dc2gtmprx) metric 20"
	    bash -c $("ip route add $domainip" + "$(($curnode_master_c[0].nodeid - 1) * 10 + 7)/32 dev $($interfaces.dc2gtmprx) metric 20")
	    bash -c $("ip route add $domainip" + "$(($curnode_master_c[0].nodeid - 1) * 10 + 1)/32 dev $($interfaces.dc2gtmprx) metric 20")
	    bash -c $("ip route add $domainip" + "$(($curnode_master_c[0].nodeid - 1) * 10 + 4)/32 dev $($interfaces.dc2gtmprx) metric 20")
	
	}
}
