BEGIN {

	
	#print role
	#print nid
	#print ms
	#print hrid

	#toSplit="a_b_c";
	#split(toSplit, tmpip, "_");





} 
{
	tmpipk[""]="";
	tmpipv[1]="";
	if($2 == hrid && $5 == cluster) {
		switch (role){
			case "gtm":
				if($6 != $10){
					if(currsm == "m"){
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
					if(currsm == "m"){
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
					if(currsm == "m"){
						ipstr=$9","$13
					} else {
						ipstr=$9
					}
				} else {
					ipstr=$9
				}
				print ipstr
				break
			case "coor":
				#print 123
				#print $7 $8 $9 $10
				if(!($7 in tmpipk) && ($7 != "-")){tmpipk[$7]; tmpipv[1]=$7}
				if(!($8 in tmpipk) && ($8 != "-")){tmpipk[$8]; tmpipv[length(tmpipk) + 1]=$8}
				if(!($9 in tmpipk) && ($9 != "-")){tmpipk[$9]; tmpipv[length(tmpipk) + 1]=$9}
				if(currsm == "m"){
					#print 111
					if(!($11 in tmpipk) && ($11 != "-")){tmpipk[$11]; tmpipv[length(tmpipk) + 1]=$11}
					if(!($12 in tmpipk) && ($12 != "-")){tmpipk[$12]; tmpipv[length(tmpipk) + 1]=$12}
					if(!($13 in tmpipk) && ($13 != "-")){tmpipk[$13]; tmpipv[length(tmpipk) + 1]=$13}
				}
				#print length(tmpipk);
				for (i = 1; i <= length(tmpipk); i++) {
					#print ipstr
					ipstr=tmpipv[i]","ipstr
				}
				gsub(/,,/,",",ipstr)
				gsub(/,,/,",",ipstr)
				gsub(/,,/,",",ipstr)
				gsub(/^,/,"",ipstr)
				gsub(/^,/,"",ipstr)
				gsub(/^,/,"",ipstr)
				gsub(/,$/,"",ipstr)
				gsub(/,$/,"",ipstr)
				gsub(/,$/,"",ipstr)
				print ipstr
				break
			case "dn":
				if(!($7 in tmpipk) && ($7 != "-")){tmpipk[$7]; tmpipv[1]=$7}
				if(!($8 in tmpipk) && ($8 != "-")){tmpipk[$8]; tmpipv[length(tmpipv) + 1]=$8}
				if(!($9 in tmpipk) && ($9 != "-")){tmpipk[$9]; tmpipv[length(tmpipv) + 1]=$9}
				if(currsm == "m"){
					if(!($11 in tmpipk) && ($11 != "-")){tmpipk[$11]; tmpipv[length(tmpipv) + 1]=$11}
					if(!($12 in tmpipk) && ($12 != "-")){tmpipk[$12]; tmpipv[length(tmpipv) + 1]=$12}
					if(!($13 in tmpipk) && ($13 != "-")){tmpipk[$13]; tmpipv[length(tmpipv) + 1]=$13}
				}
				#print length(tmpipk);
				for (i = 1; i <= length(tmpipk); i++) {
					ipstr=tmpipv[i]","ipstr
				}
				gsub(/,,/,",",ipstr)
				gsub(/,,/,",",ipstr)
				gsub(/,,/,",",ipstr)
				gsub(/^,/,"",ipstr)
				gsub(/^,/,"",ipstr)
				gsub(/^,/,"",ipstr)
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
