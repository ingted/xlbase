include ../Makefile.inc

all: base 

base:
	@echo -e ">>> pacemaker image <<<"
	@echo -e "\t---@ $$(pwd)"
	@if [ "$(PEN)" == "1" ]; then ./pcmk_pgxl95.sh -f $(BASENAME):$(BASEVERSION) -t $(PACENAME):$(PACEVERSION); fi
