#!/bin/bash

service pcsd restart || true
service corosync restart || true
service pacemaker restart || true

