#!/bin/bash



cluster=$1
theone=$2
password=$3
notAnsible=$4

dhost=$5

#dexx=$(which dexx)

#if [ "$dexx" == "" ]; then
#	cd ~;
#	git clone https://github.com/ingted/xlbase.git
#	cd xlbase
#	git checkout --track -b xlbase remotes/origin/backToOrigin
#	source alias/util-disable-status 1 1 1
#	./make.sh 1
#	source ~/.bashrc
#else
#	cd ~/xlbase
#	git reset --hard
#	git pull
#	source alias/util-disable-status 1 1 1
#        ./make.sh 1
#	source ~/.bashrc
#fi

cd ~/xlbase/mgmt

#./mgmt-init-set-xl-config $cluster

sudo=$(if [ "$(whoami)" != root ]; then echo sudo; else echo ""; fi )


dhosts=$(./mgmt-xl-get-host-by-role docker $cluster);
#dhosts=$6
dnss=$(./mgmt-xl-get-dns $cluster)
#dnss=$7
allhosts=$(./mgmt-xl-get-host-by-role -a $cluster); 
#allhosts=$8 
#which dexx
dip=$(./mgmt-xl-get-ip $dhost $cluster)
#dip=$9
#echo $cluster $theone $password $notAnsible $dhost $dip
ssh $dip << EOF
	sudo="$sudo"
	eval "\$sudo hostnamectl set-hostname \"$dhost\""
	cdip="$dip"
	diprp=\${cdip//./\\\.}
	eval "\$sudo sed -i.bak -r s/#ListenAddress[[:space:]]\\+[[:digit:]]\\+\\.[[:digit:]]\\+\\.[[:digit:]]\\+\\.[[:digit:]]\\+/ListenAddress\\ \\\$diprp/g /etc/ssh/sshd_config"
	eval "\$sudo sed -i.bak -e s/#PermitRootLogin\\ yes/PermitRootLogin\\ yes/g /etc/ssh/sshd_config"
	eval "\$sudo service ssh restart"

EOF
echo 5=========================================
ssh $dip << 'EOF'
	touch ~/.hushlogin
	expp=$(which expect)
	if [ "$expp" == "" ]; then
		if [ "$(whoami)" == "root" ]; then
	        	apt-get -y  --force-yes  install expect
		else
			sudo apt-get -y  --force-yes  install expect
		fi
	fi

	IFPS1=$(grep ps1ed ~/.bashrc)
	if [ "$IFPS1" == "" ]; then 
		echo 'export PS1="\[\e[0;33m\][\$(date  +\"%T\")]\[\e]0;\u@\$(hostname):\ \w\a\]${debian_chroot:+(\$debian_chroot)}\[\033[01;36m\]\u@\$(hostname)\[\033[00m\]:\[\033[01;32m\]\w\[\033[00m\]\\\$ "' >> ~/.bashrc
		echo "#ps1ed" >> ~/.bashrc

	fi
	if [ "$(whoami)" == "root" ]; then
		sed -i '/8\.8\.8\.8/d' /etc/resolv.conf
		sed -i '/168\.95\.1\.1/d' /etc/resolv.conf
		bash -c "echo \"nameserver 8.8.8.8\" >> /etc/resolv.conf"
		bash -c "echo \"nameserver 168.95.1.1\" >> /etc/resolv.conf"
	else
		sudo sed -i '/8\.8\.8\.8/d' /etc/resolv.conf
                sudo sed -i '/168\.95\.1\.1/d' /etc/resolv.conf
                sudo bash -c "echo \"nameserver 8.8.8.8\" >> /etc/resolv.conf"
                sudo bash -c "echo \"nameserver 168.95.1.1\" >> /etc/resolv.conf"
	fi
EOF
	
for ah in $allhosts; do
	ahip=$(./mgmt-xl-get-ip $ah $cluster)
	ahip_r=${ahip//./\\\.}

	ssh $dip << EOF
		sudo="$sudo"
		eval "\$sudo cp /etc/hosts /etc/hosts.tmp"
		eval "\$sudo sed -i \"/$ahip_r/d\" /etc/hosts.tmp"
		eval "\$sudo sed -i \"/\\ $ah\\ /d\" /etc/hosts.tmp"
		eval "\$sudo sed -i \"/\\ $ah\\$/d\" /etc/hosts.tmp"
		eval "\$sudo bash -c \"echo \\\"$ahip $ah\\\" >> /etc/hosts.tmp\""
		eval "\$sudo cp /etc/hosts.tmp /etc/hosts -f"
EOF

done
echo 6=========================================
if [ $notAnsible == 1 ] || [ "$(whoami)" != "root" ]; then
	for ddhost in $dhosts; do
		dhip=$(./mgmt-xl-get-ip $dhost $cluster)
		sleep=2
		ssh $dip << EOF
			#tarpath=\$(dirname \$(which dexxhosts))/../mgmt
	                #cd \$tarpath
			sudo="$sudo"
			ssh-keygen -R "$ddhost"
			ssh-keygen -R "$dhip"
			ssh-keyscan -H "$ddhost" >> ~/.ssh/known_hosts
			ssh-keyscan -H "$dhip" >> ~/.ssh/known_hosts
	     		eval "\$sudo bash -c 'echo \"$dhost\" > /etc/hostname'"
	   	     	#eval "\$sudo hostnamectl set-hostname \"$dhost\""
			expect -c "
	                        spawn ssh-copy-id $ddhost
	                        exec sleep $sleep
				set conti \"1\"
	                        expect {
	                                \"password:\" {
						send_user \"password:\"
						set conti \"1\"
	                                        send \"$password\\n\"
	                                }
	                                \"(yes/no)?\" {
						set conti \"1\"
	                                        send \"yes\\n\"
	                                }
	                                \"already exist\" {
						set conti \"0\"
	                                }
					\"All keys were skipped\" {
						set conti \"0\"
					}
	                        }
				if [ string match \\\$conti \"1\" ] {
	                        	expect {
						\"(yes/no)?\" {
	                                        	send \"yes\\n\"
							expect {
								\"password:\" {
									send_user \"password:\"
	                	                                        send \"$password\\n\"
									expect eof
			                                        }

							}
	                                	}
	                        	        \"password:\" {
	                        	                send \"$password\\n\"
							expect eof
	                        	        }
	                        	}
				}
	                        exit
	                "
EOF
	echo 7=========================================
	done
fi


for ad in $dnss; do
	ad_r=${ad//,/ }
	ad_ipo=($ad_r)
	ad_ip=${ad_ipo[0]}
	echo =======================================================
	echo $ad_r $ad_ipo $ad_ipi
	echo =======================================================
	ssh $dip << EOF
		eval "\$sudo cp /etc/hosts /etc/hosts.tmp"
		eval "\$sudo sed -i \"/$ad_ip/d\" /etc/hosts.tmp"
		eval "\$sudo sed -i \"/\\ $ad\\ /d\" /etc/hosts.tmp"
		eval "\$sudo sed -i \"/\\ $ad\\$/d\" /etc/hosts.tmp"
		eval "\$sudo bash -c \"echo \\\"$ad_r\\\" >> /etc/hosts.tmp\""
		eval "\$sudo cp /etc/hosts.tmp /etc/hosts -f"
EOF

done
ssh $dip << EOF
	if [ -e ~/.hushlogin ]; then rm ~/.hushlogin; fi
EOF

echo "endseploginsh"
