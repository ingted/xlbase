include ../Makefile.inc

all: base 

base:
	@echo -e ">>> pacemaker image <<<"
	@echo -e "\t---@ $$(pwd)"
	@if $[ "$(PEN)" == "1" $]; then ./pcmk_pgxl95.sh -f $(PACENAME):$(PACEVERSION) -t $(UTILNAME):$(UTILVERSION); fi
