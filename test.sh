#!/bin/bash
a=1
echo $a
echo $$
bash << 'SSH_L1'
		echo "$a"
		echo $$
		pwd
		echo $1
#                if [ "$1" == "-a" ]; then
                        for id in $(dls -ll); do
                                echo "$id: "
                                docker exec $id ${*:2}
                        done
#                else
#                        docker exec $1 ${@:2}
#                fi

SSH_L1
echo ""
