include ../Makefile.inc

.PHONY: all build test tag_latest release ssh

all: build

build:
	@echo -e ">>> util image <<<"
	@echo -e "\t---@ $$(pwd)"
	@#$(UEN) if [ "$$UEN" == "1" ]; then docker build -t $(UTILNAME):$(UTILVERSION) --rm image; fi
	@$(EXP) $(UEN) if [ "$$UEN" == "1" ]; then $(DB) $(UTILNAME):$(UTILVERSION) --rm; fi

test:
	env NAME=$(UTILNAME) VERSION=$(UTILVERSION) ./test/runner.sh

tag_latest:
	docker tag -f $(UTILNAME):$(UTILVERSION) $(UTILNAME):latest

release: test tag_latest
	@if ! docker images $(UTILNAME) | awk '{ print $$2 }' | grep -q -F $(UTILVERSION); then echo -e "$(UTILNAME) version $(UTILVERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(UTILNAME)
	@echo -e "*** Don't forget to create a tag. git tag rel-$(UTILVERSION) && git push origin rel-$(UTILVERSION)"

ssh:
	chmod 600 image/services/sshd/keys/insecure_key
	@ID=$$(docker ps | grep -F "$(UTILNAME):$(UTILVERSION)" | awk '{ print $$1 }') && \
		if test "$$ID" = ""; then echo -e "Container is not running."; exit 1; fi && \
		IP=$$(docker inspect $$ID | grep IPAddr | sed 's/.*: "//; s/".*//') && \
		echo -e "SSHing into $$IP" && \
		ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i image/services/sshd/keys/insecure_key root@$$IP
