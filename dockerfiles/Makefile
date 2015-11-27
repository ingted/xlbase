include ../Makefile.inc

all: base

base:
	@echo -e ">>> xlbase image <<<"
	@../bashrc
	@echo -e "\t---@ $$(pwd)"
	@if [ "$(BEN)" == "1" ]; then $(DB) $(BASENAME):$(BASEVERSION); fi

