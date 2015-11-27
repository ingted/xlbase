BASENAME = robotica/xlbase
BASEVERSION = latest
PACENAME = robotica/pcmk_ubuntu
PACEVERSION = latest
UTILNAME = robotica/util
UTILVERSION = latest

DB=dbuild

ifeq ($$(DISABLEBASE), 0)
  BEN = 0
else
  BEN = 1
endif

ifeq ($$(DISABLEPACE), 0)
  PEN = 0
else
  PEN = 1
endif

ifeq ($$(DISABLEUTIL), 0)
  UEN = 0
else
  UEN = 1
endif

SHELL = /bin/bash
