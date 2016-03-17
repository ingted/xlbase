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


if [ "$3" == "NULL" ] || [ "$notAnsible" == 0 ]; then
	password="/'],lp123"
elif [ "$3" == "" ];  then
	echo -n Set Password:
	read -s password
	if [ "$password" == "" ]; then
	        password="/'],lp123"
	fi
else
	password=$3
fi

if [ "$6" == "NULL" ] || [ "$notAnsible" == 0 ]; then
        ifDebugExpect=$6
elif [ "$6" == "" ];  then
        echo -n Set ifDebug:
        read ifDebugExpect
        if [ "$ifDebugExpect" == "" ]; then
		ifDebugExpect=0
        fi
else
        ifDebugExpect=$6
fi


dhost_i=$5

echo -e "\npreparing login...$cluster"

#	expp=$(which expect)
#	if [ "$expp" == "" ]; then
#		sudo apt-get -y --force-yes install expect
#	fi
#	
#	dhosts=$(./mgmt-xl-get-host-by-role docker $cluster);
#	dnss=$(./mgmt-xl-get-dns $cluster)
#	#Because the containers are not ready yet, so not do this 
#	# (key scan should not be performed)
#	# (add container hosts to /etc/hosts still needed) now...
#	allhosts=$(./mgmt-xl-get-host-by-role -a $cluster); 
#	
#	for ah in $allhosts; do
#		ahip=$(./mgmt-xl-get-ip $ah $cluster)
#		ahip_r=${ahip//./\\\.}
#		echo "/etc/hosts: $ahip"
#		sudo cp /etc/hosts /etc/hosts.tmp
#		sudo sed -i "/$ahip_r/d" /etc/hosts.tmp
#		sudo sed -i "/\ $ah\ /d" /etc/hosts.tmp
#		sudo sed -i "/\ $ah\$/d" /etc/hosts.tmp
#		sudo bash -c "echo \"$ahip $ah\" >> /etc/hosts.tmp"
#		sudo cp /etc/hosts.tmp /etc/hosts -f
#	
#	done
#	
#	user_exists=$(id -u $theone > /dev/null 2>&1; echo $?)
#	#if [ "$user_exists" == 0 ]; then
#	if [ "$theone" != root ] && [ "$theone" != "" ] && [ "$user_exists" == 0 ]; then
#		#passwd -l $theone lock account
#		#rm /home/$theone -rf
#		#userdel -r $theone	
#		useradd --system -U -ms /bin/bash $theone;
#	#fi
#	
#		mkdir -p /home/$theone
#	fi
#	sed -i.bak -e s/$theone\:\!/$theone\:\$6\$H1W8BGOe\$zue0LuGmqohKdjJiF1GCKD7r3XuJWniuqXfavfoLSUmH9FdkGZi9maI597swe0AkiMJuoxLO9PbuwH8Le6aEq1/g /etc/shadow;
#	
#	
#	for dhost in $dhosts; do
###	echo ./mgmt-xl-get-ip $dhost $cluster
###	dip=$(./mgmt-xl-get-ip $dhost $cluster)
###	#if [ "$dip" != "" ]; then
###	
###	echo "processing... $dip: $dhost"
###   	echo 1=========================================
###	#fi   	
###	if [ $notAnsible == 1 ]; then
###	     	ssh-keygen -R $dip
###     		ssh-keygen -R $dhost
###	fi
###     	echo 2=========================================
###	if [ $notAnsible == 1 ]; then
###	     	ssh-keyscan -H $dip >> ~/.ssh/known_hosts
###     		ssh-keyscan -H $dhost >> ~/.ssh/known_hosts
###	fi
###     	echo 3=========================================
###	if [ $notAnsible == 1 ]; then
###		if [ ! -e ~/.ssh/id_rsa ] || [ ! -e ~/.ssh/id_rsa.pub ]; then
###			echo 3.1=======================================
###			./genkey.expect	
###		fi
###     		./login.expect $dip "$password" #> /dev/null
###	fi
#	done

#echo ./interact.expect "" $theone $password "" "" "./sepgit.sh" "endsepgitsh"
#./interact.expect "" $theone $password "" "" "./sepgit.sh" "endsepgitsh"
function procit (){
		if [ "$(echo $dhost|grep -P "(\d+\.){3}\d+")" == "" ]; then
			echo ./mgmt-xl-get-ip $dhost $cluster
			dip=$(./mgmt-xl-get-ip $dhost $cluster)	
		else
			dip=$dhost
			dhost=$(./mgmt-xl-get-host-by-ip $dip $cluster)
		fi
		#if [ "$dip" != "" ]; then
		echo "processing... $dip: $dhost"
		
		echo 4=========================================
		if [ $notAnsible == 1 ]; then
			#su "$theone"	
			echo no more theone=root
		fi
		echo "O==============theone is $theone==============="
		#echo O=========================================
		#echo ./interact.expect $cluster theone password $notAnsible $dhost "\"$1 ./login.part1.sh  \"" "endsepsshsh" $ifDebugExpect
		#echo O=========================================
		#./interact.expect $cluster $theone $password $notAnsible $dhost "$1 ./login.part1.sh  " "endsepsshsh" $ifDebugExpect
		if [ "$2" == 0 ]; then
			echo ./interact.expect $cluster theone password $notAnsible $dhost "\"$1 ./sepssh.sh\"" "endsepsshsh" $ifDebugExpect
			echo O=========================================
			./interact.expect $cluster $theone $password $notAnsible $dhost "$1 ./sepssh.sh" "endsepsshsh" $ifDebugExpect
		else
			echo ./interact.expect $cluster theone password $notAnsible $dhost "\"$1 ./seplogin.sh\"" "endseploginsh" $ifDebugExpect
			echo O=========================================
			scp ~/.ssh/id_rsa* $theone@$dhost:~/.ssh/
			./interact.expect $cluster $theone $password $notAnsible $dhost "$1 ./seplogin.sh" "endseploginsh" $ifDebugExpect
		fi
}

echo notAnsible: $notAnsible == 1
if [ $notAnsible == 1 ]; then
	#echo procit
	dhosts=$(./mgmt-xl-get-host-by-role docker $cluster);
        for dhost in $dhosts; do
		#sudo sed -i "/$theone/d" /etc/sudoers
		#sudo bash -c "echo \"$theone ALL=NOPASSWD:ALL\" >> /etc/sudoers"


		expect << EOF
		        spawn ssh $dhost;
		        set timeout 5
		        set ay "0"
		        set ap "0"
		        sleep 1
		        expect {
		                -re {.*password\: $} {
		                        if { \$ap == "0" } {
		                                send "$password\n"
		                                set ap "1"
		                        }
		                        exp_continue
		                }
		                -re {.*\(yes/no\)\? $} {
		                        if { \$ay == "0" } {
		                                #puts "\n\nBUFFER: \$expect_out(buffer) ]]]\n"
		                                sleep 1
		                                exp_send "yes\n"
		                                set ay "1"
		                        }
		                        exp_continue
		                }
		                -re {((.|[[:space:]])*($|#))? $} {
		                        puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n------------------------"
		                }
		        }
		
		        send "sudo bash -c \"echo $theone ALL=NOPASSWD:ALL >> /etc/sudoers; \"; exit\n";
		        expect {
		                -re {\[sudo\] password(.|[[:space:]])*\: } {
		                        send "$password\n"
		                        sleep 1
		                }
		        }
EOF










		procit "" 0
	done

        for dhost in $dhosts; do
		procit "" 1
	done
else
	#if [ "$(whoami)" != root ]; then sudo=sudo; else sudo=""; fi
	dhost=$dhost_i
	echo "Enter Ansible Mode:"
	procit "\nwai=$\(whoami); if \[ $\wai != root \]; then sudo=sudo; else sudo=\\\"\\\"; fi
		cd ~/xlbase/; $\sudo git reset --hard; $\sudo git pull --no-edit; cd ~/xlbase/mgmt; "
	procit "\ncd ~/xlbase/mgmt; "
fi

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

#done

echo eofloginsh
