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

echo -e "\npreparing login..."

expp=$(which expect)
if [ "$expp" == "" ]; then
	apt-get -y install expect
fi

hosts=$(./mgmt-xl-get-host-by-cluster $cluster);
dhosts=$(./mgmt-xl-get-base $cluster 3 h \$1);
chosts=$(./mgmt-xl-get-base $cluster 3 c);
dnss=$(./mgmt-xl-get-dns $cluster)
allhosts=$(./mgmt-xl-get-host-by-role -a $cluster); 


expstr="
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

for dhost in $dhosts; do
	for ch in $chosts; do
		chh=(${ch//,/ })
		chost=${chh[0]}
		cnm=${chh[1]}
		echo "processing... $chost of $dhost"
		echo 1========================================c
		ssh $dhost "ssh-keygen -R $chost; ssh-keygen -R $cnm; ssh-keyscan -H $chost >> ~/.ssh/known_hosts; ssh-keyscan -H $cnm >> ~/.ssh/known_hosts"
		echo 2========================================c
		sleep=2
		VAR=$(ssh $dhost << EOF
			#tarpath=\$(dirname \$(which dexxhosts))/../mgmt
			#cd \$tarpath
			
			if [ ! -e ~/.ssh/id_rsa ] || [ ! -e ~/.ssh/id_rsa.pub ]; then
				./genkey.expect
				expect -c "
					spawn ssh-keygen -b 2048 -t rsa
					expect \"id_rsa):\"
					send \"\r\"
					expect {
						\"Enter passphrase (empty for no passphrase):\" {
							send \"\r\"
							expect {
								\"Enter same passphrase again:\" {
									send \"\r\"
								}
							}
						}
						\"Overwrite (y/n)?\" {
							send \"y\r\"
							expect {
								\"passphrase (empty for no passphrase):\" {
									send \"\r\"
									expect {
										\"Enter same passphrase again:\" {
											send \"\r\"
										}
									}
								}
							}
						}
					}
					expect {
						SHA256 {
							
						}
					}"
			fi
			#cd \$tarpath
			#./login.expect $chost "$password" $sleep
			#cd \$tarpath
			#./login.expect $cnm   "$password" $sleep

	        	expect -c "
	        	        spawn ssh-copy-id $chost
	        	        exec sleep $sleep
	        	        $expstr
	        	"
			expect -c "
                                spawn ssh-copy-id $cnm
                                exec sleep $sleep
				$expstr
                        "

EOF
)

		echo 3========================================c
	done
done


for ch in $chosts; do
	chh=(${ch//,/ })
	chost=${chh[0]}
	cnm=${chh[1]}
	./login.expect $chost "$password" $sleep
	./login.expect $cnm   "$password" $sleep
        for hh in $hosts; do
                hhh=(${hh//,/ })
                hhost=${hhh[0]}
                hhnm=${hhh[1]}
                echo "processing... $hhost($hhnm) of $chost($cnm)"

                echo 4========================================c
                ssh $chost "ssh-keygen -R $hhost; ssh-keygen -R $hhnm; ssh-keyscan -H $hhost >> ~/.ssh/known_hosts; ssh-keyscan -H $hhnm >> ~/.ssh/known_hosts"
                echo 5========================================c
                sleep=2
                VAR=$(ssh $chost << EOF
			expp=\$(which expect)
			if [ "\$expp" == "" ]; then
			        apt-get -y install expect
			fi

                        expect -c "
                                spawn ssh-copy-id $hhost
                                exec sleep $sleep
				$expstr
                        "
                        expect -c "
                                spawn ssh-copy-id $hhnm
                                exec sleep $sleep
				$expstr
			"
EOF
)
		echo \$VAR
                echo 6========================================c
        done
done

#	ssh $cip << 'EOF'
#		touch ~/.hushlogin
#   	     	expp=$(which expect)
#   	     	if [ "$expp" == "" ]; then
#   	     	        apt-get -y install expect
#   	     	fi
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#   	     	IFPS1=$(grep ps1ed ~/.bashrc)
#		if [ "$IFPS1" == "" ]; then 
#   			echo 'export PS1="\[\e[0;33m\][\$(date  +\"%T\")]\[\e]0;\u@\$(hostname):\ \w\a\]${debian_chroot:+(\$debian_chroot)}\[\033[01;36m\]\u@\$(hostname)\[\033[00m\]:\[\033[01;32m\]\w\[\033[00m\]\\\$ "' >> ~/.bashrc
#	     		echo "#ps1ed" >> ~/.bashrc
# 	     	fi
#   	     	sed -i '/8\.8\.8\.8/d' /etc/resolv.conf
#   	     	sed -i '/168\.95\.1\.1/d' /etc/resolv.conf
#   	     	echo "nameserver 8.8.8.8" >> /etc/resolv.conf
#   	     	echo "nameserver 168.95.1.1" >> /etc/resolv.conf
#EOF
#	
#	ssh $cip << EOF
#		ssh-keygen -R "$host"
#		ssh-keyscan -H "$host" >> ~/.ssh/known_hosts
#   		bash -c 'echo "$host" > /etc/hostname'
#   	    	hostnamectl set-hostname "$host"
#EOF
#	
#	for ah in $allhosts; do
#		ahip=$(./mgmt-xl-get-ip $ah $cluster)
#		ahip_r=${ahip//./\\\.}
#
#		ssh $cip << EOF
#			cp /etc/hosts /etc/hosts.tmp
#			sed -i "/$ahip_r/d" /etc/hosts.tmp
#			echo "$ahip $ah" >> /etc/hosts.tmp
#			cp /etc/hosts.tmp /etc/hosts -f
#EOF
#
#	done
#
#	for ad in $dnss; do
#		ad_r=${ad//,/ }
#		ad_ipo=($ad_r)
#		ad_ip=${ad_ipo[0]}
#		echo =======================================================
#		echo $ad_r $ad_ipo $ad_ipi
#		echo =======================================================
#		ssh $cip << EOF
#			cp /etc/hosts /etc/hosts.tmp
#			sed -i "/$ad_ip/d" /etc/hosts.tmp
#			echo "$ad_r" >> /etc/hosts.tmp
#			cp /etc/hosts.tmp /etc/hosts -f
#EOF
#
#	done
#	ssh $cip << EOF
#		if [ -e ~/.hushlogin ]; then rm ~/.hushlogin; fi
#EOF



echo eofcloginsh
