ssh-keygen -R gt
theone=test; password=1111;
expect << EOF
	set script1 {
	   set x 1
	   set j 2
	   set k [expr \$x / \$j.]
	}
	set script2 {
	   set x 1
	   set j 2
	   set k [expr { \$x / double(\$j) }]
	}
	foreach v { script1 script2 } {
	   puts "\$v: [time [set \$v] 10000]"
	}

	spawn bash;
	send "ssh gt\n"
	set timeout 2
	sleep 1
	set st 0
	puts "\n\n\n\n\n\$st================\n"
	expr { \$st + 1 }
	expect {
		{a} {
			puts "\na\n"
			
		}
		-re {(.|[[:space:]])} {
			set st [expr { \$st + 1 }]
			puts "\n---------\$st \n"; exp_continue
		}

	}
	puts "\nddddddddddddddddddddddd\n"
	expect eof
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
