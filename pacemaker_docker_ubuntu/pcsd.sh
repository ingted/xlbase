#!/bin/bash

sed -e s/$1/$(hostname)/g /etc/hosts > /etc/ttc

sed -i.bak '/xl95gtmsby/d' /etc/ttc
sed -i.bak '/xl95cd1/d' /etc/ttc

echo "10.128.112.46 xlbase-pm1" >> /etc/ttc
echo "10.128.112.47 xlbase-pm2" >> /etc/ttc

cp /etc/ttc /etc/hosts -f

cp /usr/libexec/pacemaker/crmd /usr/lib/pacemaker/crmd -f
