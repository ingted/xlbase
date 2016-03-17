#!/bin/bash



#cluster=$1
#theone=$2
#password=$3
#notAnsible=$4

#dhost=$5

dexx=$(which dexx)

sudo=$(if [ "$(whoami)" != root ]; then echo sudo; else echo ""; fi )

export VISUAL=vim
export EDITOR="$VISUAL"

vimed=$(grep "#vimed" ~/.bashrc); 
if [ "$exped" == "" ]; then sed -i -e "/#vimed/d"  ~/.bashrc; 
	eval "$sudo bash -c \"echo \\\"export VISUAL=vim; export EDITOR=\\\\\\\"\\\\\\\$VISUAL\\\\\\\"; #vimed\\\" >> ~/.bashrc;\""
fi


if [ "$dexx" == "" ]; then
        cd ~;
        eval "$sudo git clone https://github.com/ingted/xlbase.git"
        cd xlbase
        eval "$sudo git checkout --track -b xlbase remotes/origin/backToOrigin"
	eval "$sudo git remote set-url origin git@github.com:ingted/xlbase.git"
        source alias/util-disable-status 1 1 1
        ./make.sh 1
        source ~/.bashrc
else
        cd ~/xlbase
	eval "$sudo git remote set-url origin git@github.com:ingted/xlbase.git"
	eval "$sudo git rm mgmt/ansible/ -r"
	eval "$sudo rm mgmt/ansible -rf"
        eval "$sudo git reset --hard"
	#eval "$sudo git pull --no-edit"
	eval "egpl \"/home/$2/.ssh/id_rsa.pub\""
        source alias/util-disable-status 1 1 1
        ./make.sh 1
        source ~/.bashrc
fi


cp alpha/h1/id_rsa* ~/.ssh -f
chmod 500 ~/.ssh/id_rsa* -f



echo "endsepgitsh"

