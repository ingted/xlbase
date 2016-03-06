#!/bin/bash



cluster=$1
theone=$2
password=$3
notAnsible=$4

dhost=$5
dhosts=$(./mgmt-xl-get-host-by-role docker $cluster);
dnss=$(./mgmt-xl-get-dns $cluster)
allhosts=$(./mgmt-xl-get-host-by-role -a $cluster); 

dip=$(./mgmt-xl-get-ip $dhost $cluster)
ssh $dip << EOF
	cdip="$dip"
	diprp=\${cdip//./\\\.}
	sudo sed -i.bak -r s/#ListenAddress[[:space:]]\+[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+/ListenAddress\ \$diprp/g /etc/ssh/sshd_config
	sudo sed -i.bak -e s/#PermitRootLogin\ yes/PermitRootLogin\ yes/g /etc/ssh/sshd_config
	sudo service ssh restart

EOF
echo 5=========================================
ssh $dip << 'EOF'
	touch ~/.hushlogin
	expp=$(which expect)
	if [ "$expp" == "" ]; then
	        sudo apt-get -y  --force-yes  install expect
	fi

	IFPS1=$(grep ps1ed ~/.bashrc)
	if [ "$IFPS1" == "" ]; then 
		echo 'export PS1="\[\e[0;33m\][\$(date  +\"%T\")]\[\e]0;\u@\$(hostname):\ \w\a\]${debian_chroot:+(\$debian_chroot)}\[\033[01;36m\]\u@\$(hostname)\[\033[00m\]:\[\033[01;32m\]\w\[\033[00m\]\\\$ "' >> ~/.bashrc
		echo "#ps1ed" >> ~/.bashrc

	fi
	sudo sed -i '/8\.8\.8\.8/d' /etc/resolv.conf
	sudo sed -i '/168\.95\.1\.1/d' /etc/resolv.conf
	sudo bash -c "echo \"nameserver 8.8.8.8\" >> /etc/resolv.conf"
	sudo bash -c "echo \"nameserver 168.95.1.1\" >> /etc/resolv.conf"
EOF
	
for ah in $allhosts; do
	ahip=$(./mgmt-xl-get-ip $ah $cluster)
	ahip_r=${ahip//./\\\.}

	ssh $dip << EOF
		sudo cp /etc/hosts /etc/hosts.tmp
		sudo sed -i "/$ahip_r/d" /etc/hosts.tmp
		sudo sed -i "/\ $ah\ /d" /etc/hosts.tmp
		sudo sed -i "/\ $ah\$/d" /etc/hosts.tmp
		sudo bash -c "echo \"\$ahip \$ah\" >> /etc/hosts.tmp"
		sudo cp /etc/hosts.tmp /etc/hosts -f
		#ssh-keygen -R $ah
		#ssh-keyscan -H $ah >> ~/.ssh/known_hosts
		#ssh-keygen -R $ahip
		#ssh-keyscan -H $ahip >> ~/.ssh/known_hosts
EOF

done
echo 6=========================================
if [ $notAnsible == 1 ]; then
	for ddhost in $dhosts; do
		dhip=$(./mgmt-xl-get-ip $dhost $cluster)
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
				set conti \"1\"
	                        expect {
	                                \"password:\" {
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
		sudo cp /etc/hosts /etc/hosts.tmp
		sudo sed -i "/$ad_ip/d" /etc/hosts.tmp
		sudo sed -i "/\ $ad\ /d" /etc/hosts.tmp
		sudo sed -i "/\ $ad\$/d" /etc/hosts.tmp
		sudo bash -c "echo \"$ad_r\" >> /etc/hosts.tmp"
		sudo cp /etc/hosts.tmp /etc/hosts -f
EOF

done
ssh $dip << EOF
	if [ -e ~/.hushlogin ]; then rm ~/.hushlogin; fi
EOF

echo "endseploginsh"
