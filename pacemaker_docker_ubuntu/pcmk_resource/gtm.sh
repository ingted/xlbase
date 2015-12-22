#!/bin/bash

name="gtm"

mypath="/etc/init.d"
lib_path="/root/xlbase/mgmt"

export PATH=$PATH:$mypath

case "$1" in
    start)
        launcher.py --start -d $lib_path -n $name
        ;;
    stop)
        launcher.py --stop -d $lib_path -n $name
        ;;
    status)
        launcher.py --status -d $lib_path -n $name
        ;;
    *)
        echo "Usage : ${name} {start|stop|status}"
        exit 1

esac

exit 0
