ssh-keygen -R gt
theone=test; password=1111;
expect << EOF
	spawn bash;
	send "ssh gt\n"
	set timeout 2
	sleep 1
	set alreadyyes "0"
	expect {
		-re {hosts\.[[:space:]]*[^']*'s password\: $} {
			send "$password\n"
			puts "\nhhhhhtttthh\n"
		}
		-re {(yes/no)? $} {
			puts "\n\nBUFFER111: \$expect_out(buffer) ]]]\n"
			if { \$alreadyyes == "0" } {
	            		exp_send "yes\r"
				puts "nnnnnnn"
				set alreadyyes "1"
			}
			puts "\$alreadyyes --\n"
			exp_continue
		}

		#-re {((.|[[:space:]])*($|#))? $}{exit}
		#-re "." {puts "fffffff"; exp_continue}
	}
	puts "oooooooooooooooo"
	expect {
		-re {.} {puts "\nuiuuuuuu\n"}
	 	-re {((.|[[:space:]])*($|#))? $}{
			send "sudo sed -i \"/$theone/d\" /etc/sudoers; exit\n"; 
			expect {
				-re {[sudo] password(.|[[:space:]])*\: }{
					send "$password\n"
				}
				eof
			}
		}
		eof {
		}
	}
	
EOF

exit 0

expect << EOF
	spawn bash;
	send "ssh gt -o StrictHostKeyChecking=no\n"
	set timeout 2
	sleep 1
	expect {
		-re {(yes/no)? } {
            		exp_send "yes\r"
			sleep 1
			expect {
				#-re {[[:space:]]test@gs's password\: } {puts "\nuiuuuuuu000\n"}
				-re {hosts\.[[:space:]]*[^']*'s password\: $} {
					send "$password\n"
					#puts "\nuiuuuuuu000\n"
					exp_continue
				}
				#-re {hosts}{puts "\nhhkkk\n"}
				-re {.*password\: $}{
					puts "\nhhhhhhh\n"
					send "$password\n"
				}
			}
		}
		-re {hosts\.[[:space:]]*[^']*'s password\: $} {
			puts "\nhhhhhhh\n"
			send "$password\n"
			exit

		}
		-re {((.|[[:space:]])*($|#))? $}{exit}
		-re "." {puts"fffffff"}
	}
	expect {
		-re {password\: }{
                        puts "\nhhhhhhh\n"
                        send "$password\n"
                        exit

                }
	}
	puts "oooooooooooooooo"
	expect {
		-re {.} {puts "\nuiuuuuuu\n"}
	 	-re {((.|[[:space:]])*($|#))? $}{
			send "sudo sed -i \"/$theone/d\" /etc/sudoers; exit\n"; 
			expect {
				-re {[sudo] password(.|[[:space:]])*\: }{
					send "$password\n"
				}
				eof
			}
		}
		eof {
		}
	}
	
EOF
