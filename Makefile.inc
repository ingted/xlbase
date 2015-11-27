BASENAME = robotica/xlbase
BASEVERSION = latest
PACENAME = robotica/pcmk_ubuntu
PACEVERSION = latest
UTILNAME = robotica/util
UTILVERSION = latest

DB=dbuild

ifeq ($$(DISABLEBASE), 1)
  BEN = 0
else
  BEN = 1
endif

ifeq ($$(DISABLEPACE), 1)
  PEN = 0
else
  PEN = 1
endif

ifeq ($$(DISABLEUTIL), 1)
  UEN = 0
else
  UEN = 1
endif

SHELL = /bin/bash
