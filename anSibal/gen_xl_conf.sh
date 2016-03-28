#!/bin/bash
domain=$1
hostsfile=$2
outfils=$4
cluster=$3

if [ -n "$hostsfile" ] && [ -n "$hostsfile" ] && [ -n "$outfils" ] && [ -n "$outfils" ];then
	domain1=`echo $domain|awk -F "." '{print $1"."$2"."$3"."}'`
	cluster=$3
	count=-3

	conf_hosts="$4/dexxhosts"
	conf_hostinfo="$4/dexxhostinfo"
	conf_hostroles="$4/dexxhostroles"
	conf_hostips="$4/dexxhostips"
	conf_matserslave="$4/dexxmasterslave"

	rm -f ${conf_hosts} ${conf_hostinfo} ${conf_hostroles} ${conf_hostips} ${conf_matserslave}

	echo -e "mgmt\thrID\ttype\treside\tcluster\ttoGTM\ttoClient\ttoVolt\tinXL\thaGTM\thaClient\thavolt\thaXL" >> ${conf_hostips}

	cat $hostsfile | while read -r line
	do
		count=$((${count}+1))
		if [ $count -eq -2 ];then
			host_name="gt"
		elif [ $count -eq -1 ];then
			host_name="gs"
		else 
			host_name="h${count}"
		fi
		#dexxhosts
		echo -e "${line}\t${host_name}\th\t-\t-\t${cluster}" >> ${conf_hosts}
		#dexxhostroles
		echo -e "${host_name}\t0\tdocker\tx\tx\t${cluster}\t$((${count}+3))" >> ${conf_hostroles}
		#dexxhostips
		echo -e "$line\t$((${count}+3))\th\t-\t${cluster}\t-\t-\t-\t-\t-\t-\t-\t-" >> ${conf_hostips}
	done

	host_count=$(($(awk 'END{print NR}' $2) - 2 ))

    #dexxhostinfo
        echo -e "gtm\t#\t1\t${cluster}" >> ${conf_hostinfo}
        echo -e "gtmsby\t#\t1\t${cluster}" >> ${conf_hostinfo}
        echo -e "gtmprx\t#\t${host_count}\t${cluster}" >> ${conf_hostinfo}
        echo -e "coor\t#\t${host_count}\t${cluster}" >> ${conf_hostinfo}
        echo -e "dn\t#\t${host_count}\t${cluster}" >> ${conf_hostinfo}  

	count=-3
	cat $2 | while read -r line
	do
		count=$((${count}+1))
        if [ $count -eq -2 ];then
            host_name="gt"
			ip_num_start="250"
			gtm_vip="252"
        elif [ $count -eq -1 ];then
            host_name="gs"
			ip_num_start="251"
			gtm_vip="252"
        else 
            host_name="h${count}"
			ip_num_start=$((${count}*10))
			role1="gtmprx$((${count}+1))m"
			role2="coor$((${count}+1))m"
			role3="dn$((${count}+1))m"
			role1_s="gtmprx$((${count}+1))s"
			role2_s="coor$((${count}+1))s"
			role3_s="dn$((${count}+1))s"
			role4="gtmprx$((${host_count}-${count}))s"
			role5="coor$((${host_count}-${count}))s"
			role6="dn$((${host_count}-${count}))s"
        fi
        #dexxhosts
		dd="/docker_volume/"
		if [ $count -eq -2 ];then
			echo -e "${domain1}${ip_num_start}\tgtm\tc\t${host_name}\t${dd}gtm\t${cluster}" >> ${conf_hosts}
		elif [ $count -eq -1 ];then
			echo -e "${domain1}${ip_num_start}\tgtmsby\tc\t${host_name}\t${dd}gtmsby\t${cluster}" >> ${conf_hosts}
		else
			echo -e "${domain1}$((${ip_num_start}+1))\t${role1}\tc\t${host_name}\t${dd}${role1}\t${cluster}" >> ${conf_hosts}
			echo -e "${domain1}$((${ip_num_start}+2))\t${role2}\tc\t${host_name}\t${dd}${role2}\t${cluster}" >> ${conf_hosts} 
			echo -e "${domain1}$((${ip_num_start}+3))\t${role3}\tc\t${host_name}\t${dd}${role3}\t${cluster}" >> ${conf_hosts} 
            echo -e "${domain1}$((${ip_num_start}+4))\t${role4}\tc\t${host_name}\t${dd}${role4}\t${cluster}" >> ${conf_hosts}
            echo -e "${domain1}$((${ip_num_start}+5))\t${role5}\tc\t${host_name}\t${dd}${role5}\t${cluster}" >> ${conf_hosts}
            echo -e "${domain1}$((${ip_num_start}+6))\t${role6}\tc\t${host_name}\t${dd}${role6}\t${cluster}" >> ${conf_hosts}
		fi
        #dexxhostroles
        if [ $count -eq -2 ];then
			echo -e "gtm\t0\tgtm\tg\tm\t${cluster}\t$((${host_count}+${count}+5))" >> ${conf_hostroles}			
        elif [ $count -eq -1 ];then
			echo -e "gtmsby\t0\tgtmsby\tg\ts\t${cluster}\t$((${host_count}+${count}+5))" >> ${conf_hostroles}
        else
            echo -e "${role1}\t$((${count}+1))\tgtmprx\tg\tm\t${cluster}\t$((${host_count}+${count}*6+5))" >> ${conf_hostroles}
            echo -e "${role2}\t$((${count}+1))\tcoor\tc\tm\t${cluster}\t$((${host_count}+${count}*6+6))" >> ${conf_hostroles}
            echo -e "${role3}\t$((${count}+1))\tdn\td\tm\t${cluster}\t$((${host_count}+${count}*6+7))" >> ${conf_hostroles}
            echo -e "${role4}\t$((${host_count}-${count}))\tgtmprx\tg\ts\t${cluster}\t$((${host_count}+${count}*6+8))" >> ${conf_hostroles}
            echo -e "${role5}\t$((${host_count}-${count}))\tcoor\tc\ts\t${cluster}\t$((${host_count}+${count}*6+9))" >> ${conf_hostroles}
            echo -e "${role6}\t$((${host_count}-${count}))\tdn\td\ts\t${cluster}\t$((${host_count}+${count}*6+10))" >> ${conf_hostroles}
        fi
        #dexxhostips
        if [ $count -eq -2 ];then
			echo -e "${domain1}${ip_num_start}\t$((${host_count}+${count}+5))\tc\t${host_name}\t${cluster}\t${domain1}${ip_num_start}\t-\t-\t-\t${domain1}${gtm_vip}\t-\t-\t-" >> ${conf_hostips}
        elif [ $count -eq -1 ];then
			echo -e "${domain1}${ip_num_start}\t$((${host_count}+${count}+5))\tc\t${host_name}\t${cluster}\t${domain1}${ip_num_start}\t-\t-\t-\t${domain1}${gtm_vip}\t-\t-\t-" >> ${conf_hostips}
        else
			echo -e "${domain1}$((${ip_num_start}+1))\t$((${host_count}+${count}*6+5))\tc\t${host_name}\t${cluster}\t-\t-\t-\t${domain1}$((${ip_num_start}+1))\t-\t-\t-\t${domain1}$((${ip_num_start}+7))" >> ${conf_hostips}
			echo -e "${domain1}$((${ip_num_start}+2))\t$((${host_count}+${count}*6+6))\tc\t${host_name}\t${cluster}\t-\t${domain1}$((${ip_num_start}+2))\t${domain1}$((${ip_num_start}+2))\t-\t-\t${domain1}$((${ip_num_start}+8))\t${domain1}$((${ip_num_start}+8))\t-" >> ${conf_hostips}
            echo -e "${domain1}$((${ip_num_start}+3))\t$((${host_count}+${count}*6+7))\tc\t${host_name}\t${cluster}\t-\t-\t${domain1}$((${ip_num_start}+3))\t-\t-\t-\t${domain1}$((${ip_num_start}+9))\t-" >> ${conf_hostips}
			if [ $count -eq 0 ];then
                echo -e "${domain1}$((${ip_num_start}+4))\t$((${host_count}+${count}*6+8))\tc\t${host_name}\t${cluster}\t-\t-\t-\t${domain1}$((${ip_num_start}+4))\t-\t-\t-\t${domain1}$((${ip_num_start}+${host_count}*10-3))" >> ${conf_hostips}
                echo -e "${domain1}$((${ip_num_start}+5))\t$((${host_count}+${count}*6+9))\tc\t${host_name}\t${cluster}\t-\t${domain1}$((${ip_num_start}+5))\t${domain1}$((${ip_num_start}+5))\t-\t-\t${domain1}$((${ip_num_start}+${host_count}*10-2))\t${domain1}$((${ip_num_start}+${host_count}*10-2))\t-" >> ${conf_hostips}
                echo -e "${domain1}$((${ip_num_start}+6))\t$((${host_count}+${count}*6+10))\tc\t${host_name}\t${cluster}\t-\t-\t${domain1}$((${ip_num_start}+6))\t-\t-\t-\t${domain1}$((${ip_num_start}+${host_count}*10-1))\t-" >> ${conf_hostips}
			else
                echo -e "${domain1}$((${ip_num_start}+4))\t$((${host_count}+${count}*6+8))\tc\t${host_name}\t${cluster}\t-\t-\t-\t${domain1}$((${ip_num_start}+4))\t-\t-\t-\t${domain1}$((${ip_num_start}-3))" >> ${conf_hostips}
                echo -e "${domain1}$((${ip_num_start}+5))\t$((${host_count}+${count}*6+9))\tc\t${host_name}\t${cluster}\t-\t${domain1}$((${ip_num_start}+5))\t${domain1}$((${ip_num_start}+5))\t-\t-\t${domain1}$((${ip_num_start}-2))\t${domain1}$((${ip_num_start}-2))\t-" >> ${conf_hostips}
                echo -e "${domain1}$((${ip_num_start}+6))\t$((${host_count}+${count}*6+10))\tc\t${host_name}\t${cluster}\t-\t-\t${domain1}$((${ip_num_start}+6))\t-\t-\t-\t${domain1}$((${ip_num_start}-1))\t-" >> ${conf_hostips}
			fi
        fi
		#dexxmasterslave
        if [ $count -eq -2 ];then
			echo -e "gtm\tgtmsby\tgtm\t${cluster}" >> ${conf_matserslave}
        elif [ $count -eq -1 ];then
			echo -e "gtm\tgtmsby\tgtm\t${cluster}" >> /dev/null
        else
			echo -e "${role1}\t${role1_s}\tgtmprx\t${cluster}" >> ${conf_matserslave}
			echo -e "${role2}\t${role2_s}\tcoor\t${cluster}" >> ${conf_matserslave}
			echo -e "${role3}\t${role3_s}\tdn\t${cluster}" >> ${conf_matserslave}
        fi
	done
	`chmod 755 $4/dexx*`
else
	echo "wrong args!!"
	echo $0 [domain] [tmp_hostpath] [cluster_name] [target_path]
fi

