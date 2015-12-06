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

hosts=$(./mgmt-xl-get-host-by-role docker $cluster);
allhosts=$(./mgmt-xl-get-host-by-role -a $cluster); 
for host in $hosts; do
	echo ./mgmt-xl-get-ip $host $cluster
	cip=$(./mgmt-xl-get-ip $host $cluster)
	echo "processing... $cip"
	ssh-keygen -R $cip
	ssh-keyscan -H $cip >> ~/.ssh/known_hosts
	./login.expect $cip $password > /dev/null
	ssh $cip << 'EOF'
		IFPS1=$(grep ps1ed ~/.bashrc)
		if [ "$IFPS1" == "" ]; then 
			echo 'export PS1="\[\e[0;33m\][\$(date  +\"%T\")]\[\e]0;\u@\$(hostname):\ \w\a\]${debian_chroot:+(\$debian_chroot)}\[\033[01;36m\]\u@\$(hostname)\[\033[00m\]:\[\033[01;32m\]\w\[\033[00m\]\\\$ "' >> ~/.bashrc
			echo "#ps1ed" >> ~/.bashrc
		fi
EOF
	ssh $cip << EOF
		bash -c 'echo \"$host\" > /etc/hostname'
		hostnamectl set-hostname \"$host\"
		
EOF
		#for ah in $allhosts; do
		#done


done
