BASENAME = robotica/xlbase
BASEVERSION = latest1
PACENAME = robotica/pcmk_ubuntu
PACEVERSION = latest1
UTILNAME = robotica/util
UTILVERSION = latest1

DB = dbuild

BEN = if [ "$$DISABLEBASE" != "1" ]; then export BEN=1; else export BEN=0; fi;
PEN = if [ "$$DISABLEPACE" != "1" ]; then export PEN=1; else export PEN=0; fi;
UEN = if [ "$$DISABLEUTIL" != "1" ]; then export UEN=1; else export UEN=0; fi;


SHELL = /bin/bash
