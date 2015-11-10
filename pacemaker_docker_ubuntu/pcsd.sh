#!/bin/bash

sed -e s/AL2015/$(hostname)/g /etc/hosts > /etc/ttc

echo "10.128.112.46 xlbase-pm1" >> /etc/ttc
echo "10.128.112.47 xlbase-pm2" >> /etc/ttc

cp /etc/ttc /etc/hosts -f
