#ssh-keygen -R gs
theone=test; password=1111;
expect << EOF
	spawn bash;
	send "ssh gs\n"
	set timeout 2
	set ay "0"
	sleep 1
	expect {
		-re {.*password\: $} {
			send "$password\n"
			exp_continue
		}
		-re {.*\(yes/no\)\? $} {
			if { \$ay == "0" } {
				puts "\n\nBUFFER: \$expect_out(buffer) ]]]\n"
				sleep 5
	            		exp_send "yes\n"
				set ay "1"
			}
			exp_continue
		}
		-re {((.|[[:space:]])*($|#))? $}{}
	}

	send "sudo bash -c \"echo $theone ALL=NOPASSWD:ALL >> /etc/sudoers; \"; exit\n"; 
	#send "sudo bash -c \"echo \\\"$theone ALL=NOPASSWD:ALL\\\" > /etc/sudoers; exit\"\n"; 
	expect {
		-re {\[sudo\] password(.|[[:space:]])*\: }{
			send "$password\n"
		}
		eof
	}
	
EOF

exit 0
			#send "sudo sed -i \"/$theone/d\" /etc/sudoers; echo \"$theone ALL=NOPASSWD:ALL\" > /etc/sudoers; exit\n"; 
