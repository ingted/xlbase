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

#Because the containers are not ready yet, so not do this 
# (key scan should not be performed)
# (add container hosts to /etc/hosts still needed) now...
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
			echo "nameserver 8.8.8.8" >> /etc/resolv.conf
			echo "nameserver 168.95.192.1" >> /etc/resolv.conf
		fi
EOF
	ssh $cip << EOF
		bash -c 'echo \"$host\" > /etc/hostname'
		hostnamectl set-hostname \"$host\"
		
EOF
	for ah in $allhosts; do
		ahip=$(./mgmt-xl-get-ip $ah $cluster)
		ahip_r=${ahip//./\\\.}
		ssh $cip << EOF
			cp /etc/hosts /etc/hosts.tmp
			sed -i "/$ahip_r/d" /etc/hosts.tmp
			echo "$ahip $ah" >> /etc/hosts.tmp
			cp /etc/hosts.tmp /etc/hosts -f
			#ssh-keygen -R $ah
			#ssh-keyscan -H $ah >> ~/.ssh/known_hosts
			#ssh-keygen -R $ahip
			#ssh-keyscan -H $ahip >> ~/.ssh/known_hosts
EOF

	done
	ssh-keygen -R $host
	ssh-keyscan -H $host >> ~/.ssh/known_hosts


done
