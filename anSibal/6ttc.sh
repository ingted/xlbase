ssh-keygen -R gs
theone=test; password=1111;
expect << EOF
	spawn bash;
	send "ssh gs\n"
	set timeout 2
	set ay "0"
	set ap "0"
	sleep 1
	expect {
		-re {((.|[[:space:]])*($|#))? $}{
			sleep 1
			puts "\n\nBUFFER: \$expect_out(buffer) ]]]\n"
		}
		-re {.*password\: $} {
			if { \$ap == "0" } {
				send "$password\n"
				set ap "1"
			}
			exp_continue
		}
		-re {.*(yes/no)? $} {
			puts "\n\nBUFFER: \$expect_out(buffer) ]]]\n"
			if { \$ay == "0" } {
	            		exp_send "yes\n"
				set ay "1"
			}
			exp_continue
		}

	}
	sleep 2
	puts "\n---------------------------------------\n"
	sleep 2
	send "sudo bash -c \"echo $theone ALL=NOPASSWD:ALL >> /etc/sudoers; exit\"\n"; 
	expect {
		-re {\[sudo\] password(.|[[:space:]])*\: }{
			send "$password\n"
			sleep 1
			send "exit\n"
		}
		-re {((.|[[:space:]])*($|#))? $}{
			sleep 1
                        send "exit\n"
		}
		eof
	}
	
EOF

exit 0
			#send "sudo sed -i \"/$theone/d\" /etc/sudoers; echo \"$theone ALL=NOPASSWD:ALL\" > /etc/sudoers; exit\n"; 
