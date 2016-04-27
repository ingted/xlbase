#!/usr/bin/pash
param(
	$cluster, $dexxpath, $doact, $hostname
)

#$cluster = "ansible3"
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

if($host.Version -ne ""){
    function psql {param($c, $p) $c}
    function pcs  {"pcs $args"}
    function bash {param($c) $c}
}

if ("$hostname" -eq ""){
	$hostname = hostname
}


$authnode = $htHosts |?{$_.role -ne "docker"}| %{$_.hostname}

$ofs = " "
pcs cluster auth "$authnode"

