include ../Makefile.inc

all: base

base:
	@echo -e ">>> xlbase image <<<"
	@../bashrc
	@echo -e "\t---@ $$(pwd)"
	$(EXP) $(BEN) if [ "$$BEN" == "1" ]; then $(DB) $(BASENAME):$(BASEVERSION); fi

