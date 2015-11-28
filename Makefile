include Makefile.inc


all: base pace uti1


base:
	@echo -e ">>> base <<<"
	@./bashrc

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

