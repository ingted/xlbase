BASENAME = robotica/xlbase
BASEVERSION = latest
PACENAME = robotica/pcmk_ubuntu
PACEVERSION = latest
UTILNAME = robotica/util
UTILVERSION = latest

DB = dbuild

BEN = if [ "$$DISABLEBASE" != "1" ]; then export BEN=1; else export BEN=0; fi;
PEN = if [ "$$DISABLEPACE" != "1" ]; then export PEN=1; else export PEN=0; fi;
UEN = if [ "$$DISABLEUTIL" != "1" ]; then export UEN=1; else export UEN=0; fi;
EXP = export PATH=$$PATH:"$$(dirname $$(pwd))"/alias;

SHELL = /bin/bash
