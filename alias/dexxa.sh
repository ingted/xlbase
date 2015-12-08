#!/bin/bash

if [ "$2" == "" ]; then
        cluster=test
else
        cluster=$2
fi


dcmd=${*:3}
echo "distributed command: $dcmd"
hostfil=$(which dexxhosts)
dhosts=$(awk "(\$3 == \"h\") && (\$6 == \"$cluster\") {print \$2\",\"\$1}" $hostfil)



#echo ===========\$dhosts============
#echo  $dhosts
#echo ===========\$cnms\ \ ============
#echo  $cnms
#echo ===============================


for dhi in $dhosts; do

    dhtmp=(${dhi//\,/ })
        dh=${dhtmp[1]}
    echo @ $dh
        dnm=${dhtmp[0]}
        cnms=$(awk "(\$4 == \"$dnm\") && (\$6 == \"$cluster\") {print \$2}" $hostfil)

    ssh root@$dh 'bash -s' -- < dexxb.sh $1 \'$dcmd\' $cnms
done



#sed -r 's/:Host +=> +\"[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\"/:Host               => \"\"/g' /usr/share/pcsd/ssl.rb
