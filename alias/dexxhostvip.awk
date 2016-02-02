BEGIN {

	
	#print role
	#print nid
	#print ms
	#print hrid

	#toSplit="a_b_c";
	#split(toSplit, tmpip, "_");





} 
{
	tmpip[1]="";
	if($2 == hrid && $5 == cluster) {
		switch (role){
			case "gtm":
				if($6 != $10){
					if(ms == "m"){
						ipstr=$10
					} else {
						ipstr=$6
					}
				} else {
					ipstr=$6
				}
				print ipstr
				break
			case "gtmsby":
				if($6 != $10){
					if(ms == "m"){
						ipstr=$10
					} else {
						ipstr=$6
					}
				} else {
					ipstr=$6
				}
				print ipstr
				break
			case "gtmprx":
				if($9 != $13){
					if(ms == "m"){
						ipstr=$13
					} else {
						ipstr=$9
					}
				} else {
					ipstr=$9
				}
				print ipstr
				break
			case "coor":
				if(sm == "s"){
					if($7 != "-"){tmpip[1]=$7}
					if(length(tmpip) == 0 && !($8 in tmpip) && ($8 != "-")){tmpip[1]=$8}
					if(length(tmpip) == 0 && !($9 in tmpip) && ($9 != "-")){tmpip[1]=$9}
				}
				if(sm == "m"){
					if($11 != "-"){tmpip[1]=$11}
					if(length(tmpip) == 0 && !($12 in tmpip) && ($12 != "-")){tmpip[1]=$12}
					if(length(tmpip) == 0 && !($13 in tmpip) && ($13 != "-")){tmpip[1]=$13}
				}
				for (i = 1; i <= length(tmpip); i++) {
					ipstr=tmpip[i]","ipstr
				}
				gsub(/,$/,"",ipstr)
				gsub(/,$/,"",ipstr)
				gsub(/,$/,"",ipstr)
				print ipstr
				break
			case "dn":
				#print $13
				if(sm == "s"){
					if($7 != "-"){tmpip[1]=$7}
					else if(!($8 in tmpip) && ($8 != "-")){tmpip[1]=$8}
					else if(!($9 in tmpip) && ($9 != "-")){tmpip[1]=$9}
				}
				if(sm == "m"){
					if($11 != "-"){tmpip[1]=$11}
					else if(!($12 in tmpip) && ($12 != "-")){tmpip[1]=$12}
					else if(!($13 in tmpip) && ($13 != "-")){tmpip[1]=$13}
				}
				for (i = 1; i <= length(tmpip); i++) {
					ipstr=tmpip[i]","ipstr
				}
				gsub(/,$/,"",ipstr)
				gsub(/,$/,"",ipstr)
				gsub(/,$/,"",ipstr)
				print ipstr
				break
			default:
	        		break
	    	}
		#tmpip[1]=$1;
		#print $1;
	}


}


END {







}
