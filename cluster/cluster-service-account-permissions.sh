#!/bin/bash




function main(){

	if [ "$nm" == "" ]; then
		echo "user required!"
		helptext 999
	fi
	chown "$nm":"$nm" /postgres -R
	chown "$nm":"$nm" /root/pcmk -R
}
function helptext() {
        echo ""
        echo "cluster-service-account-permissions - A tool for initialize cluster service accounts permission."
        echo ""
        echo "Usage: cluster-service-account-permissions.sh [options]"
        echo ""
        echo "Options:"
        echo "-n, --nm, --name         \"Service account name\""

        echo ""
        exit $1
}

cnt=$#

while true ; do
        case "$1" in
        --help|-h|-\?) helptext 0;;
        -n|--nm|--name) nm="$2"; shift; shift;;
        "") break;;
        *)
                echo "[ERROR!!] Unknown option \"$1\""
                helptext 1;;
        esac
done

if [ "$cnt" != "0" ]; then
        main
else
        helptext 1
fi

