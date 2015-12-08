#!/bin/bash
args=("$@")
needle=${args[0]}
dcmd=${args[1]}
cnms=("${args[@]:2}")

export PATH=$(cat ~/PATH.TMP) 
export PATH=$PATH:/root/xlbase/alias
dhosts_o="$dhosts"
dhosts=(${dhosts_o//\\n/ })

if [ "$needle" == "-a" ]; then

    ids="$($(which dls) -ll)"
    #echo "ids: \$ids"
    ids=(${ids//\\n/ })

    if [ "$ids" == "" ]; then
        echo "no alive containers!"
    else
    

        for id in "${ids[@]}"; do
            echo "[< Server    >]" : IP\ \ \ \ \ \ \ : $dh
            echo "[< Container >]" : ID\ \ \ \ \ \ \ : $id
            echo "[< Container >]" : Username : $(/usr/bin/whoami)
            echo "[< Container >]" : Hostname : $(/bin/hostname)
            
            expath=$(docker exec $id 'pwd')
            echo "[< Container >]" : PATH\ \ \ \ \ : $expath
            #docker exec \$id ${*:2}
            echo '/bin/bash -c "$dcmd"'
            docker exec $id /bin/bash -c "$dcmd"
        done 
        IFS=ifsold
    fi
else
    echo Docker Host Mode: \(Please specify docker container ID\)
    array_contains2 () { 
        local array="$1[@]"
        local seeking=$2
        local in=1
        for element in "${!array}"; do
            if [[ $element == $seeking ]]; then
                in=0
                break
            fi
        done
        return $in
    }
    dlss=$($(which dls) -ll)
    dlsss=(${dlss//\\n/ })            
    #Do not support IP so far...
    r1=0
    array_contains2 dlsss $needle && r1=1
    r2=0
    array_contains2 cnms $needle && r2=1
    if [[ $r1 == 1 ]] || [[ $r2 == 1 ]]; then 
        docker exec $needle $dcmd 
    else
        echo Wrong container ID!
    fi
fi 
