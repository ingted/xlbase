#!/bin/bash



if [ "$1" == "" ]; then
	echo -n Enter the cluster name:
	read cluster
	
	if [ "$cluster" == "" ]; then
	        cluster=test
	fi
else
	cluster=$1

fi

if [ "$2" == "" ]; then
	echo -n Set User:
	read theone
	if [ "$theone" == "" ]; then
	        theone="root"
	fi
else
	theone=$2
fi

chpwd=0

if [ "$3" == "" ]; then
	echo -n Set Password:
	read -s password
	if [ "$password" == "" ]; then
	        password="/'],lp123"
	else
		chpwd=1
	fi
else
	chpwd=1
	password=$3
fi

if [ "$4" == "" ]; then
        echo -n Set ifAnsible:
        read Ansible
        if [ "$Ansible" == "" ]; then
                notAnsible=0
        else
                notAnsible=1
        fi
else
        if [ "$4" != 1 ]; then
                notAnsible=0
        else
                notAnsible=1
        fi
fi


if [ "$5" == "" ]; then
	echo -n Set MyPassword:
	read -s mypassword
	if [ "$mypassword" == "" ]; then
	        mypassword="/'],lp123"
	fi
else
	mypassword=$5
fi
ifDebugAnsible=$6
#if [ "$4" != 1 ]; then
#	notAnsible=1
#else
#	notAnsible=0
#fi 
sudo=$(if [ "$(whoami)" != root ]; then echo sudo; else echo ""; fi )
echo -e "\npreparing login...$cluster $sudo"

expect << EOF
        spawn $sudo sed -ir "s/^\[\[:space:]]*$(whoami).*/$(whoami) ALL=NOPASSWD:ALL/g" /etc/sudoers
        expect {
                -re {\[sudo\] password for(.|[[:space:]])*$} {
                        sleep 1
                        send "$mypassword\n"
                }
        }
EOF




expp=$(which expect)
if [ "$expp" == "" ]; then
	eval "$sudo apt-get -y --force-yes install expect"
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
	echo "/etc/hosts: $ahip"
	eval "$sudo cp /etc/hosts /etc/hosts.tmp -f"
	eval "$sudo sed -i \"/$ahip_r/d\" /etc/hosts.tmp"
	eval "$sudo sed -i \"/\ $ah\ /d\" /etc/hosts.tmp"
	eval "$sudo sed -i \"/\ $ah\$/d\" /etc/hosts.tmp"
	#eval $sudo bash -c "echo \"$ahip $ah\" >> /etc/hosts.tmp"
	eval "$sudo bash -c \"echo \\\"$ahip $ah\\\" >> /etc/hosts.tmp\""
	#echo "$sudo bash -c \"echo \\\"$ahip $ah\\\" >> /etc/hosts.tmp\""
	eval "$sudo cp /etc/hosts.tmp /etc/hosts -f"

done

user_exists=$(id -u $theone > /dev/null 2>&1; echo $?) # 1 means not existed
#if [ "$user_exists" == 0 ]; then
if [ "$theone" != root ] && [ "$theone" != "" ] && [ "$user_exists" == 1 ]; then
	#passwd -l $theone lock account
	#rm /home/$theone -rf
	#userdel -r $theone	
	eval "$sudo useradd --system -U -ms /bin/bash $theone";
#fi

	#eval "$sudo mkdir -p /home/$theone"
#else
	#eval "$sudo userdel -r $theone"
	#eval "$sudo useradd --system -U -ms /bin/bash $theone";
fi
eval "$sudo mkdir -p /home/$theone/.ssh"
eval "$sudo chown $theone:$theone /home/$theone/ -Rf"
if [ "$(whoami)" != root ]; then
        #if [ "$(whoami)" == $theone ]; then
                eval "$sudo chmod +w /home/$theone/.ssh/id_rsa* -f"
                eval "$sudo cp ../alpha/h1/id_rsa* /home/$theone/.ssh -f"
                eval "$sudo chmod 500 /home/$theone/.ssh/id_rsa* -f"
        #else
        #       cp ../alpha/h1/id_rsa* /home/$(whoami)/.ssh -f
        #       chmod 500 /home/$(whoami)/.ssh/id_rsa* -f
        #fi
else
        eval "$sudo chmod +w /root/.ssh/id_rsa* -f"
        eval "$sudo cp ../alpha/h1/id_rsa* /root/.ssh -f"
        eval "$sudo chmod 500 /root/.ssh/id_rsa* -f"
fi

#eval "$sudo sed -i.bak -e s/$theone\\:[^\\:]+/$theone\\:\\\$6\\\$H1W8BGOe\\\$zue0LuGmqohKdjJiF1GCKD7r3XuJWniuqXfavfoLSUmH9FdkGZi9maI597swe0AkiMJuoxLO9PbuwH8Le6aEq1/g /etc/shadow";
if [ "$chpwd" == 1 ]; then
	echo "pwd changed!!!"
	expect << EOF
	        spawn $sudo passwd $theone
		expect {
			-re {password\:(.|[[:space:]])*$} {
				sleep 1
				send "$password\n"
				sleep 1
				expect {
					-re {password\:(.|[[:space:]])*$} {
						sleep 1
		                                send "$password\n"
					}
				}
			}
		}
		expect eof
EOF
else
	eval "$sudo sed -i.bak -e \"s/$theone\\:[^\\:]*/$theone\\:\\\$6\\\$H1W8BGOe\\\$zue0LuGmqohKdjJiF1GCKD7r3XuJWniuqXfavfoLSUmH9FdkGZi9maI597swe0AkiMJuoxLO9PbuwH8Le6aEq1/g\" /etc/shadow"
fi

echo --------------------------------------------------------------------------------------

eval "$sudo usermod -aG docker $theone"
#eval "$sudo usermod -aG root $theone"
#eval "$sudo sed -i \"/$theone/d\" /etc/sudoers"
eval "$sudo bash -c \"sed -i \\\"/$theone/d\\\" /etc/sudoers; echo \\\"$theone ALL=NOPASSWD:ALL\\\" >> /etc/sudoers\""

for dhost in $dhosts; do

	dip=$(./mgmt-xl-get-ip $dhost $cluster)
	./interact.expect "$dip" "$theone" "$password" "" "$dhost" "./login.part2.sh" "endloginpart2" $ifDebugAnsible

done
#for dhost in $dhosts; do
#	echo ./mgmt-xl-get-ip $dhost $cluster
#	dip=$(./mgmt-xl-get-ip $dhost $cluster)
#	#if [ "$dip" != "" ]; then
#	
#	echo "processing... $dip: $dhost"
#   	echo 1=========================================
#	#fi   	
#	if [ $notAnsible == 1 ]; then
#	     	ssh-keygen -R $dip
#     		ssh-keygen -R $dhost
#	fi
#     	echo 2=========================================
#	if [ $notAnsible == 1 ]; then
#	     	ssh-keyscan -H $dip >> ~/.ssh/known_hosts
#     		ssh-keyscan -H $dhost >> ~/.ssh/known_hosts
#	fi
#     	echo 3=========================================
#	if [ $notAnsible == 1 ]; then
#		if [ ! -e ~/.ssh/id_rsa ] || [ ! -e ~/.ssh/id_rsa.pub ]; then
#			echo 3.1=======================================
#			./genkey.expect	
#		fi
#     		./login.expect $dip "$password" #> /dev/null
#	fi
#done

echo "./interact.expect \"\" theone password \"\" \"\" \"./sepgit.sh\" \"endsepgitsh\" $ifDebugAnsible"
./interact.expect "" "$theone" "$password" "" "" "./sepgit.sh" "endsepgitsh" $ifDebugAnsible

###	for dhost in $dhosts; do
###	        echo ./mgmt-xl-get-ip $dhost $cluster
###	        dip=$(./mgmt-xl-get-ip $dhost $cluster)
###	        #if [ "$dip" != "" ]; then
###	        echo "processing... $dip: $dhost"
###	
###	     	echo 4=========================================
###		if [ $notAnsible == 1 ]; then
###			#su "$theone"	
###			theone=root
###		fi
###		echo "===============theone is $theone==============="
###	
###		echo ./interact.expect $cluster $theone $password $notAnsible $dhost "./sepssh.sh" "endsepsshsh"
###		./interact.expect $cluster $theone $password $notAnsible $dhost "./sepssh.sh" "endsepsshsh"
	#echo ./interact.expect $cluster $theone $password $notAnsible $dhost "./seplogin.sh" "endseploginsh"
	#./interact.expect $cluster $theone $password $notAnsible $dhost "./seplogin.sh" "endseploginsh"



#	ssh $dip << EOF
#		cdip="$dip"
#		diprp=\${cdip//./\\\.}
#		sudo sed -i.bak -r s/#ListenAddress[[:space:]]\+[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+/ListenAddress\ \$diprp/g /etc/ssh/sshd_config
#		sudo sed -i.bak -e s/#PermitRootLogin\ yes/PermitRootLogin\ yes/g /etc/ssh/sshd_config
#		sudo service ssh restart
#
#EOF
#	echo 5=========================================
#	ssh $dip << 'EOF'
#		touch ~/.hushlogin
#		expp=$(which expect)
#		if [ "$expp" == "" ]; then
#		        sudo apt-get -y  --force-yes  install expect
#		fi
#	
#		IFPS1=$(grep ps1ed ~/.bashrc)
#		if [ "$IFPS1" == "" ]; then 
#			echo 'export PS1="\[\e[0;33m\][\$(date  +\"%T\")]\[\e]0;\u@\$(hostname):\ \w\a\]${debian_chroot:+(\$debian_chroot)}\[\033[01;36m\]\u@\$(hostname)\[\033[00m\]:\[\033[01;32m\]\w\[\033[00m\]\\\$ "' >> ~/.bashrc
#			echo "#ps1ed" >> ~/.bashrc
#	
#		fi
#		sudo sed -i '/8\.8\.8\.8/d' /etc/resolv.conf
#		sudo sed -i '/168\.95\.1\.1/d' /etc/resolv.conf
#		sudo bash -c "echo \"nameserver 8.8.8.8\" >> /etc/resolv.conf"
#		sudo bash -c "echo \"nameserver 168.95.1.1\" >> /etc/resolv.conf"
#EOF
#	
#	for ah in $allhosts; do
#		ahip=$(./mgmt-xl-get-ip $ah $cluster)
#		ahip_r=${ahip//./\\\.}
#
#		ssh $dip << EOF
#			sudo cp /etc/hosts /etc/hosts.tmp
#			sudo sed -i "/$ahip_r/d" /etc/hosts.tmp
#			sudo sed -i "/\ $ah\ /d" /etc/hosts.tmp
#			sudo sed -i "/\ $ah\$/d" /etc/hosts.tmp
#			sudo bash -c "echo \"\$ahip \$ah\" >> /etc/hosts.tmp"
#			sudo cp /etc/hosts.tmp /etc/hosts -f
#			#ssh-keygen -R $ah
#			#ssh-keyscan -H $ah >> ~/.ssh/known_hosts
#			#ssh-keygen -R $ahip
#			#ssh-keyscan -H $ahip >> ~/.ssh/known_hosts
#EOF
#
#	done
#     	echo 6=========================================
#	if [ $notAnsible == 1 ]; then
#		for ddhost in $dhosts; do
#        		dhip=$(./mgmt-xl-get-ip $dhost $cluster)
#			sleep=2
#			ssh $dip << EOF
#				#tarpath=\$(dirname \$(which dexxhosts))/../mgmt
#        	                #cd \$tarpath
#				ssh-keygen -R "$ddhost"
#				ssh-keygen -R "$dhip"
#				ssh-keyscan -H "$ddhost" >> ~/.ssh/known_hosts
#				ssh-keyscan -H "$dhip" >> ~/.ssh/known_hosts
#   		     		bash -c 'echo "$dhost" > /etc/hostname'
#		   	     	hostnamectl set-hostname "$dhost"
#				expect -c "
#        	                        spawn ssh-copy-id $ddhost
#        	                        exec sleep $sleep
#					set conti \"1\"
#        	                        expect {
#        	                                \"password:\" {
#							set conti \"1\"
#        	                                        send \"$password\\n\"
#        	                                }
#        	                                \"(yes/no)?\" {
#							set conti \"1\"
#        	                                        send \"yes\\n\"
#        	                                }
#        	                                \"already exist\" {
#							set conti \"0\"
#        	                                }
#						\"All keys were skipped\" {
#							set conti \"0\"
#						}
#        	                        }
#					if [ string match \\\$conti \"1\" ] {
#        	                        	expect {
#							\"(yes/no)?\" {
#        	                                        	send \"yes\\n\"
#								expect {
#									\"password:\" {
#		                	                                        send \"$password\\n\"
#										expect eof
#        			                                        }
#
#								}
#        	                                	}
#        	                        	        \"password:\" {
#        	                        	                send \"$password\\n\"
#								expect eof
#        	                        	        }
#        	                        	}
#					}
#		                        exit
#        	                "
#EOF
#     		echo 7=========================================
#		done
#	fi
#
#
#	for ad in $dnss; do
#		ad_r=${ad//,/ }
#		ad_ipo=($ad_r)
#		ad_ip=${ad_ipo[0]}
#		echo =======================================================
#		echo $ad_r $ad_ipo $ad_ipi
#		echo =======================================================
#		ssh $dip << EOF
#			sudo cp /etc/hosts /etc/hosts.tmp
#			sudo sed -i "/$ad_ip/d" /etc/hosts.tmp
#			sudo sed -i "/\ $ad\ /d" /etc/hosts.tmp
#			sudo sed -i "/\ $ad\$/d" /etc/hosts.tmp
#			sudo bash -c "echo \"$ad_r\" >> /etc/hosts.tmp"
#			sudo cp /etc/hosts.tmp /etc/hosts -f
#EOF
#
#	done
#	ssh $dip << EOF
#		if [ -e ~/.hushlogin ]; then rm ~/.hushlogin; fi
#EOF

###	done

echo eofloginsh
