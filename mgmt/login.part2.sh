#!/bin/bash

dip=$1
dhost=$5
password=$3
echo "processing... $dip: $dhost"
echo 1=========================================

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
./login.expect $dip "$password"


