#!/bin/bash




echo -n Enter the cluster name:
read cluster

if [ "$cluster" == "" ]; then
        cluster=test
fi


echo -n Set Password:
read -s password


if [ "$password" == "" ]; then
        password="/'],lp123"
fi

echo -e "\npreparing login...$cluster"

expp=$(which expect)
if [ "$expp" == "" ]; then
	apt-get -y --force-yes install expect
fi

dhosts=$(./mgmt-xl-get-host-by-role docker $cluster);
dnss=$(./mgmt-xl-get-dns $cluster)
#Because the containers are not ready yet, so not do this 
# (key scan should not be performed)
# (add container hosts to /etc/hosts still needed) now...
allhosts=$(./mgmt-xl-get-host-by-role -a $cluster); 

for ah in $allhosts; do
	ahip=$(./mgmt-xl-get-ip $ah $cluster)
	ahip_r=${ahip//./\\\.}

	cp /etc/hosts /etc/hosts.tmp
	sed -i "/$ahip_r/d" /etc/hosts.tmp
	sed -i "/\ $ah\ /d" /etc/hosts.tmp
	sed -i "/\ $ah\$/d" /etc/hosts.tmp
	echo "$ahip $ah" >> /etc/hosts.tmp
	cp /etc/hosts.tmp /etc/hosts -f

done



for dhost in $dhosts; do
	echo ./mgmt-xl-get-ip $dhost $cluster
	dip=$(./mgmt-xl-get-ip $dhost $cluster)
	#if [ "$dip" != "" ]; then
	echo "processing... $dip: $dhost"
   	echo 1=========================================
	#fi   	
     	ssh-keygen -R $dip
     	ssh-keygen -R $dhost
     	echo 2=========================================
     	ssh-keyscan -H $dip >> ~/.ssh/known_hosts
     	ssh-keyscan -H $dhost >> ~/.ssh/known_hosts
     	echo 3=========================================
	if [ ! -e ~/.ssh/id_rsa ] || [ ! -e ~/.ssh/id_rsa.pub ]; then
		echo 3.1=======================================
		./genkey.expect	
	fi
     	./login.expect $dip "$password" > /dev/null
     	echo 4=========================================
	ssh $dip << EOF
		cdip="$dip"
		diprp=\${cdip//./\\\.}
		sed -i.bak -r s/#ListenAddress[[:space:]]\+[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+/ListenAddress\ \$diprp/g /etc/ssh/sshd_config
		sed -i.bak -e s/#PermitRootLogin\ yes/PermitRootLogin\ yes/g /etc/ssh/sshd_config
		service ssh restart

EOF
     	ssh $dip << 'EOF'
     		touch ~/.hushlogin
     		expp=$(which expect)
     		if [ "$expp" == "" ]; then
     		        apt-get -y  --force-yes  install expect
     		fi

     		IFPS1=$(grep ps1ed ~/.bashrc)
     		if [ "$IFPS1" == "" ]; then 
			echo 'export PS1="\[\e[0;33m\][\$(date  +\"%T\")]\[\e]0;\u@\$(hostname):\ \w\a\]${debian_chroot:+(\$debian_chroot)}\[\033[01;36m\]\u@\$(hostname)\[\033[00m\]:\[\033[01;32m\]\w\[\033[00m\]\\\$ "' >> ~/.bashrc
     			echo "#ps1ed" >> ~/.bashrc

     		fi
     		sed -i '/8\.8\.8\.8/d' /etc/resolv.conf
     		sed -i '/168\.95\.1\.1/d' /etc/resolv.conf
     		echo "nameserver 8.8.8.8" >> /etc/resolv.conf
     		echo "nameserver 168.95.1.1" >> /etc/resolv.conf
EOF
	
	for ddhost in $dhosts; do
        	dhip=$(./mgmt-xl-get-ip $host $cluster)
		sleep=2
		ssh $dip << EOF
			#tarpath=\$(dirname \$(which dexxhosts))/../mgmt
                        #cd \$tarpath
			ssh-keygen -R "$ddhost"
			ssh-keygen -R "$dhip"
			ssh-keyscan -H "$ddhost" >> ~/.ssh/known_hosts
			ssh-keyscan -H "$dhip" >> ~/.ssh/known_hosts
   	     		bash -c 'echo "$dhost" > /etc/hostname'
	   	     	hostnamectl set-hostname "$dhost"
			expect -c "
                                spawn ssh-copy-id $ddhost
                                exec sleep $sleep
                                expect {
                                        \"password:\" {
                                                send \"$password\\n\"
                                        }
                                        \"(yes/no)?\" {
                                                send \"yes\\n\"
                                        }
                                        \"already exist\" {
                                        }
					\"All keys were skipped\" {
					}
                                }
                                expect {
                                        \"password:\" {
                                                send \"$password\\n\"
                                        }
                                        *{}
                                }
                                expect eof
                                exit
                        "
EOF
	done
	for ah in $allhosts; do
		ahip=$(./mgmt-xl-get-ip $ah $cluster)
		ahip_r=${ahip//./\\\.}

		ssh $dip << EOF
			cp /etc/hosts /etc/hosts.tmp
			sed -i "/$ahip_r/d" /etc/hosts.tmp
			sed -i "/\ $ah\ /d" /etc/hosts.tmp
			sed -i "/\ $ah\$/d" /etc/hosts.tmp
			echo "$ahip $ah" >> /etc/hosts.tmp
			cp /etc/hosts.tmp /etc/hosts -f
			#ssh-keygen -R $ah
			#ssh-keyscan -H $ah >> ~/.ssh/known_hosts
			#ssh-keygen -R $ahip
			#ssh-keyscan -H $ahip >> ~/.ssh/known_hosts
EOF

	done

	for ad in $dnss; do
		ad_r=${ad//,/ }
		ad_ipo=($ad_r)
		ad_ip=${ad_ipo[0]}
		echo =======================================================
		echo $ad_r $ad_ipo $ad_ipi
		echo =======================================================
		ssh $dip << EOF
			cp /etc/hosts /etc/hosts.tmp
			sed -i "/$ad_ip/d" /etc/hosts.tmp
			sed -i "/\ $ad\ /d" /etc/hosts.tmp
			sed -i "/\ $ad\$/d" /etc/hosts.tmp
			echo "$ad_r" >> /etc/hosts.tmp
			cp /etc/hosts.tmp /etc/hosts -f
EOF

	done
	ssh $dip << EOF
		if [ -e ~/.hushlogin ]; then rm ~/.hushlogin; fi
EOF

done

echo eofloginsh
