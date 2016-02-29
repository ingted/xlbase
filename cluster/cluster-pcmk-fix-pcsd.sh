#!/bin/bash

function replace (){
	a=$(grep -l "/usr/lib/pcsd/" $dir -R)
	b=(${a//\\n/ })
	mapfile -t c <<< "$a"
	d=$(echo ${#b[@]})
	
	i=$(( $d - 1 ))
	while [ $(( $i >= 0 )) == 1 ]; do
		t=${c[$(( $i + 0 ))]}
	
		echo ===============================================
		echo $t
		echo ===============================================
		s=$(grep "\\.bak\$" <<< $t)
		if [ "$s" == "" ]; then
			sed -i.bak -re 's/\/usr\/lib\/pcsd\//\/usr\/share\/pcsd\//g' $t 
		fi
	
		i=$(( i - 1 ))
	done
}

dir=/usr/share/pcsd
replace

dir=/usr/lib/python2.7/dist-packages/pcs
replace


