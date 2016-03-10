include Makefile.inc


all: base pace uti1


base:
	@echo -e ">>> base <<<"
	@./bashrc
	@exped=$$(grep "#exped" ~/.bashrc); if [ "$$exped" == "" ] || [ ! -e ./exped ]; then sed -i -e "/#exped/d"  ~/.bashrc; echo "export PATH=$$(pwd)/alias:\$$PATH #exped" >> ~/.bashrc; fi
	@if [ "$$(whoami)" != root ]; then sudo touch exped; else touch exped; fi
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
