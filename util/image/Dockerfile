FROM ubuntu:14.04
MAINTAINER ingted

ADD . /bd_build

RUN cp -rf /bd_build/util /; \
	/bd_build/prepare.sh && \
	/bd_build/system_services.sh && \
	/bd_build/utilities.sh && \
	/bd_build/cleanup.sh; \
	apt-get -y update; \
	apt-get -y install git; \
	cd /util; \
	git init; \
  	git remote add -f origin https://github.com/ingted/xlbase.git; \
  	git config core.sparseCheckout true; \
  	echo "mgmt/*" >> .git/info/sparse-checkout; \
	git checkout --track -b backToOrigin origin/backToOrigin; \
	cp -rf * /opt

CMD ["/sbin/my_init"]
