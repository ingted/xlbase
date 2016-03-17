ssh-keygen -R gt
theone=test; password=1111;
expect << EOF
	#spawn bash;
	spawn ssh gt;
	#send "ssh gt\n"
	set timeout -1
	sleep 1
	expect {
		-re {(yes/no)? } {
	            	exp_send "yes\r"
			expect {
				-re {hosts\.[[:space:]]*[^']*'s password\: $} {
					send "$password\n"
					sleep 1
					#puts "\n\n\n\n--------------------\n"
					expect {
						-re {((.|[[:space:]])*($|#))? $} {
                                		        send "sudo sed -i \"/$theone/d\" /etc/sudoers; exit 0\n";
                                		        expect {
                                		                -re {\[sudo\] password(.|[[:space:]])*\: } {
                                		                        send "$password\n"
                                		                }
                                		                eof
                                		        }
                                		}
					}
				}
				-re {((.|[[:space:]])*($|#))? $}{
					send "sudo sed -i \"/$theone/d\" /etc/sudoers; exit 0; echo 1\n";
					expect {
		                                -re {\[sudo\] password(.|[[:space:]])*\: } {
                		                        send "$password\n"
                                		}
                                		eof
                        		}
				}
			}
		}
                -re {hosts\.[[:space:]]*[^']*'s password\: $} {
                        send "$password\n"
			expect {
                                -re {((.|[[:space:]])*($|#))? $}{
                                        send "sudo sed -i \"/$theone/d\" /etc/sudoers; exit 3\n";
                                        expect {
                                                -re {[sudo] password(.|[[:space:]])*\: }{
                                                        send "$password\n"
                                                }
                                                eof
                                        }
                                }
                        }
                }
                -re {((.|[[:space:]])*($|#))? $}{
                        send "sudo sed -i \"/$theone/d\" /etc/sudoers; exit 4\n";
                        expect {
                                -re {\[sudo\] password(.|[[:space:]])*\: } {
                                        send "$password\n"
                                }
                                eof
                        }
                }
	}
	send "sudo sed -i \"/$theone/d\" /etc/sudoers; exit 5\n";
	puts "\njjjjjjjj\n"
        expect {
                -re {pssword} {
                        send "$password\n"
                }
                eof
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
