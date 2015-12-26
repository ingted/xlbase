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

hosts=$(./mgmt-xl-get-host-by-role docker $cluster);
dnss=$(./mgmt-xl-get-dns $cluster)
#Because the containers are not ready yet, so not do this 
# (key scan should not be performed)
# (add container hosts to /etc/hosts still needed) now...
allhosts=$(./mgmt-xl-get-host-by-role -a $cluster); 


for host in $hosts; do
	echo ./mgmt-xl-get-ip $host $cluster
	cip=$(./mgmt-xl-get-ip $host $cluster)
	if [ "$cip" != "" ]; then
		echo "processing... $cip"
   	     	echo 1=========================================
   	     	ssh-keygen -R $cip 
   	     	echo 2=========================================
   	     	ssh-keyscan -H $cip >> ~/.ssh/known_hosts
   	     	echo 3=========================================
   	     	./login.expect $cip $password > /dev/null
   	     	echo 4=========================================
   	     	ssh $cip << 'EOF'
   	     		touch ~/.hushlogin
   	     		expp=$(which expect)
   	     		if [ "$expp" == "" ]; then
   	     		        apt-get -y install expect
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
   	     		ssh-keygen -R $host
   	     		ssh-keyscan -H $host >> ~/.ssh/known_hosts
EOF	
	fi
   	     	ssh $cip << EOF
   	     		bash -c 'echo \"$host\" > /etc/hostname'
	   	     	hostnamectl set-hostname \"$host\"
   	     	
EOF	
	


done


echo eofloginsh
