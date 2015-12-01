#!/usr/bin/pash
param(
	$ver	
)

if ($ver -eq "9.2"){
	cd /root/Downloads/pgxl/postgres-xl
	$result = make install
	$result[-1]
} elseif ($ver -eq "9.5"){
	cd /root/Downloads/pgxl95/postgres-xl
	$result = make install-world
	$result[-1]
}
