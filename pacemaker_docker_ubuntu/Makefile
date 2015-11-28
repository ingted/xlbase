include ../Makefile.inc

all: base 

base:
	@echo -e ">>> pacemaker image <<< $$PEN"
	@echo -e "\t---@ $$(pwd)"
	@$(EXP) $(PEN) if [ "$$PEN" == "1" ]; then ./pcmk_pgxl95.sh -f $(BASENAME):$(BASEVERSION) -t $(PACENAME):$(PACEVERSION); fi
