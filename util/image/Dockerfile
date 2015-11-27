FROM ubuntu:14.04
MAINTAINER Phusion <info@phusion.nl>

ADD . /bd_build

RUN cp /bd_build/util /opt/util; \
	/bd_build/prepare.sh && \
	/bd_build/system_services.sh && \
	/bd_build/utilities.sh && \
	/bd_build/cleanup.sh; \
	apt-get update; \
	apt-get install git; \
	cd /opt/util; \
	git init; \
  	git remote add -f origin https://github.com/ingted/xlbase.git; \
  	git config core.sparseCheckout true; \
  	echo "mgmt/*" >> .git/info/sparse-checkout; \
  	git pull origin backToOrigin


CMD ["/sbin/my_init"]
