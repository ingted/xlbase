ssh-keygen -R gs
theone=test; password=1111;
expect << EOF
	spawn ssh gs;
	#send "ssh gs\n"
	set timeout 5
	set ay "0"
	set ap "0"
	sleep 1
	expect {
		-re {.*password\: $} {
			if { \$ap == "0" } {
				send "$password\n"
				set ap "1"
			}
			exp_continue
		}
		-re {.*\(yes/no\)\? $} {
			if { \$ay == "0" } {
				#puts "\n\nBUFFER: \$expect_out(buffer) ]]]\n"
				sleep 1
	            		exp_send "yes\n"
				set ay "1"
			}
			exp_continue
		}
#		-re {.*}{
#			puts "\n\nBUFFER: \$expect_out(buffer) ]]]\n"
#		}
		-re {((.|[[:space:]])*($|#))? $} {
			puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n------------------------"
		}
	}

	send "sudo bash -c \"echo $theone ALL=NOPASSWD:ALL >> /etc/sudoers; \"; exit\n"; 
	#send "sudo bash -c \"echo \\\"$theone ALL=NOPASSWD:ALL\\\" > /etc/sudoers; exit\"\n"; 
	expect {
		-re {\[sudo\] password(.|[[:space:]])*\: }{
			send "$password\n"
			sleep 1
		}
	}
EOF

exit 0
			#send "sudo sed -i \"/$theone/d\" /etc/sudoers; echo \"$theone ALL=NOPASSWD:ALL\" > /etc/sudoers; exit\n"; 
