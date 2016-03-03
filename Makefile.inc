BASENAME = robotica/xlbase
BASEVERSION = latest
PACENAME = robotica/pcmk_ubuntu
PACEVERSION = latest
UTILNAME = robotica/util
UTILVERSION = latest
SHELL = #!/bin/bash 
DB = dbuild

BEN = if [ "$$BEN" == "" ]; then if [ "$$DISABLEBASE" == "1" ]; then export BEN=0; else export BEN=1; fi; else export BEN="$$BEN"; fi;
PEN = if [ "$$PEN" == "" ]; then if [ "$$DISABLEPACE" == "1" ]; then export PEN=0; else export PEN=1; fi; else export PEN="$$PEN"; fi;
UEN = if [ "$$UEN" == "" ]; then if [ "$$DISABLEUTIL" == "1" ]; then export UEN=0; else export UEN=1; fi; else export UEN="$$UEN"; fi;
EXP = export PATH="$$(dirname $$(pwd))"/alias:\$$PATH;

SHELL = /bin/bash
