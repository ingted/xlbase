include Makefile.inc


all: base pace uti1


base:
	@echo -e ">>> base <<<"
	@./bashrc
<<<<<<< HEAD
	@export PATH=$$PATH:$$(pwd)
	@echo -e "\tPATH => $$PATH"
=======
	@if [ ! -e ./exped ]; then echo "export PATH=\$$PATH:$$(pwd)/alias" >> ~/.bashrc; fi
	@touch exped
>>>>>>> 7b6221afd7275be904a24f71ae40dac72b7d9ee2
	@echo -e "\t@ $$(pwd)"
	@$(MAKE) -C dockerfiles 

pace:
	@echo -e ">>> pace <<<"
	@$(MAKE) -C pacemaker_docker_ubuntu

uti1:
	@echo -e ">>> util <<<"
	@$(MAKE) -C util
#test:


#tag_latest:

#release: test tag_latest
