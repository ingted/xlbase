#!/bin/bash
tbls=$(mysql --login-path=local -N -e"show tables;" oz_market)
tblcounts=$(mysql --login-path=local -N -e"select count(1) from information_schema.TABLES where table_schema = 'oz_market';")
mapfile -t tblarray <<< "$tbls"
#echo ${tblarray[2]}
#echo ${tblarray[4]}
i=$(( $tblcounts - 1 ))
#echo $i
tblctmp=(${tblcounts//\ /})
tblcount=${tblctmp[0]}
echo "use oz_market_sync;"
while [ $(( $i >= 0 )) == 1 ]; do
	t=${tblarray[$(( $i + 0 ))]}
	#if [ "$t" != ${tblarray[0]} ]; then
#		echo table ===$i===== $t
		pks=$(mysql --login-path=local -N -e"select column_name from information_schema.columns where table_name = '$t' and table_schema = 'oz_market' AND column_key = 'PRI';" oz_market)
		mapfile -t pkarray <<< "$pks" 
		cols=$(mysql --login-path=local -N -e"select column_name from information_schema.columns where table_name = '$t' and table_schema = 'oz_market'; " oz_market)
		mapfile -t colarray <<< "$cols"
		IFS=","
		colStr="${colarray[*]}"
		colStr=${colStr//,from,/,\`from\`,}
		#colStr="${colStr[@]}"
		IFS="#"
		tColStr="${colarray[*]}"
		tColStr=${tColStr//#from#/#\`from\`#}
		newColStr=${tColStr//#/, NEW.}
		oldColStr=${tColStr//#/, OLD.}
		#colsnotpk=$(mysql --login-path=local -N -e"select column_name from information_schema.columns where table_name = 'oz_official_image' and table_schema = 'oz_market' AND column_key <> 'PRI'; " oz_market)
		#mapfile -t colsnotpkarray  <<< "$colsnotpk"
		#if [ "${pkarray[*]}" == "" ]; then 
		#	IFS=", NEW."
		#	pk="${pkarray[@]}"

		#else
		#	echo "${pkarray[*]}"
		#fi

cat <<-OO
DELIMITER ;
DROP TRIGGER IF EXISTS \`$t``_ins\`;
DELIMITER ;;
CREATE TRIGGER \`$t``_ins\` AFTER INSERT ON \`$t\` FOR EACH ROW BEGIN
INSERT INTO \`oz_market_sync\`.\`$t``_src\` ($colStr, mode_syncaid)
values ( NEW.$newColStr, 1);
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS \`$t``_upd\`;
DELIMITER ;;
CREATE TRIGGER \`$t``_upd\` AFTER UPDATE ON \`$t\` FOR EACH ROW BEGIN
INSERT INTO \`oz_market_sync\`.\`$t``_src\` ($colStr, mode_syncaid)
values ( NEW.$newColStr, 2);
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS \`$t``_del\`;
DELIMITER ;;
CREATE TRIGGER \`$t``_del\` AFTER DELETE ON \`$t\` FOR EACH ROW BEGIN
INSERT INTO \`oz_market_sync\`.\`$t``_src\` ($colStr, mode_syncaid)
values ( OLD.$oldColStr, 3);
END
;;
DELIMITER ;
		
OO




i=$(( i - 1 ))
	#fi
done

