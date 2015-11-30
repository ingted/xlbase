#!/bin/bash




function main(){

	if [ "$nm" == "" ] || [ "$pwd" == "" ]; then
		echo "user / pwd required!"
		helptext 999
	fi

	useradd "$nm"
	if [ "$sudo" == "1" ]; then adduser "$nm" sudo; fi
	echo -e "$pwd\n$pwd\n" | passwd "$nm"

}

function helptext() {
        echo ""
        echo "cluster-service-account - A tool for initialize cluster service accounts."
        echo ""
        echo "Usage: cluster-service-account.sh [options]"
        echo ""
        echo "Options:"
        echo "-n, --nm, --name         \"Service account name\""
        echo "-p, --pwd, --password    \"Service account password\""
        echo "-i, --is, --ifSUDO       \"If bind this container immediately"

        echo ""
        exit $1
}

cnt=$#

while true ; do
        case "$1" in
        --help|-h|-\?) helptext 0;;
        -n|--nm|--name) nm="$2"; shift; shift;;
        -p|--pwd|--password) pwd=$2; shift; shift;;
        -i|--is|ifSUDO) sudo=1; shift;;
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

