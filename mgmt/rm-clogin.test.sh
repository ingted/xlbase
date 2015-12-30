#!/bin/bash

dhost=10.128.112.34
ch=10.128.112.50,dn2s
password="/'],lp123"
		chh=(${ch//,/ })
		chost=${chh[0]}
		cnm=${chh[1]}
		echo "processing... $chost of $dhost"
		echo 1=========================================
		ssh $dhost "ssh-keygen -R $chost; ssh-keygen -R $cnm; ssh-keyscan -H $chost >> ~/.ssh/known_hosts; ssh-keyscan -H $cnm >> ~/.ssh/known_hosts"
		echo 2=========================================
		sleep=2
		VAR=$(ssh $dhost << EOF
	        	expect -c "
	        	        spawn ssh-copy-id $chost
	        	        exec sleep $sleep
	        	        expect {
	        	                \"password:\" {
	        	                        send \"$password\\n\"
	        	                }
	        	                \"(yes/no)?\" {
	        	                        send \"yes\\n\"
	        	                }
	        	                \"already exist\" {
	        	                }
	        	        }
	        	        expect {
	        	                *{}
	        	        }
	        	        exit
	        	"
			expect -c "
                                spawn ssh-copy-id $cnm
                                exec sleep $sleep
                                expect {
                                        \"password:\" {
                                                send \"$password\\n\"
                                        }
                                        \"(yes/no)?\" {
                                                send \"yes\\n\"
                                        }
                                        \"already exist\" {
                                        }
                                }
                                expect {
                                        *{}
                                }
                                exit
                        "

EOF
)

		echo 3=========================================

