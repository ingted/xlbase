#!/bin/bash

sed -e s/AL2015/$(hostname)/g /etc/hosts > /etc/ttc

echo "192.168.123.99 xlbase-pm2" >> /etc/ttc
echo "192.168.123.98 xlbase-pm1" >> /etc/ttc

cp /etc/ttc /etc/hosts -f
