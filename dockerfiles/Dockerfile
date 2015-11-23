# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
#
#  FROM phusion/baseimage:<VERSION>

FROM phusion/baseimage:0.9.17
#ENTRYPOINT /bin/bash

# ...put your own build instructions here...

###apt-get autoremove


ENV DEBIAN_FRONTEND noninteractive 

ADD ./addfiles /addfiles

RUN mkdir -p /addfiles; \
	mkdir -p /root/Downloads; \
	mkdir -p /root/Sources; \
	mkdir -p /etc/my_init.d; \
        mkdir -p /docker_scripts; \
	sed -i.bak -e s/USA/USA\\\nexit\ 0\\\n/g   /usr/sbin/invoke-rc.d; \
	sed -i.bak -e s/exit\ 101/exit\ 0/g /usr/sbin/policy-rc.d; \
	apt-get -y update; \
	apt-get -y install apt-transport-https dbus binfmt-support llvm udev || true; \
        sed -i.bak -e s/BEGIN\ INIT\ INFO/BEGIN\ INIT\ INFO\\\nexit\ 0\\\n/g  /etc/init.d/udev; \
	ls -l /usr/lib/apt/methods/https; \
	cp /usr/lib/apt/methods/https /root/Downloads/https; \
 	ln -snf /root/Downloads/https /usr/lib/apt/methods/https; \
	ln -snf /bin/bash /bin/sh; \

	rm /etc/rc.local; \
        apt-get -y purge \
                libcurl3 \
                libcurl3-gnutls; \
	cp /addfiles/rc.local 			/etc/rc.local; \
	cp /addfiles/docker.list 		/etc/apt/sources.list.d/; \
	cp /addfiles/sources.list 		/etc/apt/; \
	cp /addfiles/libsystemd.so.0 		/lib/x86_64-linux-gnu/libsystemd.so.0; \
	cp /addfiles/libgcrypt.so.20 		/lib/x86_64-linux-gnu/libgcrypt.so.20; \
	cp /addfiles/timedatectl              	/usr/bin/; \
	cp /addfiles/dbus*			/usr/bin/; \
	cp /addfiles/110_logtime.sh 		/etc/my_init.d/110_logtime.sh; \
	cp /addfiles/120_dbus.sh.old 		/docker_scripts/120_dbus.sh; \
	cp /addfiles/130_ha.sh 			/docker_scripts/130_ha.sh; \
	cp /addfiles/cgroup-lite_1.9_all.deb 	/root/Downloads/cgroup-lite_1.9_all.debi

ADD ./addfiles/gnu/libgmp.so.10 \
	./addfiles/gnu/libcurl-gnutls.so.4 \    
	./addfiles/gnu/librtmp.so.1 \    
	./addfiles/gnu/libssh2.so.1 \           
	./addfiles/gnu/libnettle.so.4 \           
	./addfiles/gnu/libgnutls-deb0.so.28 \     
	./addfiles/gnu/libhogweed.so.2 \         
	./addfiles/gnu/libcap-ng.so.0		/usr/lib/x86_64-linux-gnu/

RUN sed -i.bak -e s/exit\ 101/exit\ 0/g /usr/sbin/policy-rc.d; \
	ln -s /bin/true /etc/init.d/systemd-logind; \
 	ln -snf /root/Downloads/https /usr/lib/apt/methods/https; \
        apt-get purge openjdk-7-*; \
        apt-get purge openjdk-8-*; \
	echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections; \
        echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections; \
        apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D; \
	rm /var/lib/apt/lists/* -vrf; \
	apt-get -y update

RUN	bash -c "if [ -e /var/run/dbus/system_bus_socket ]; then rm /var/run/dbus/system_bus_socket; fi"; \
        bash /docker_scripts/120_dbus.sh; \
        service dbus status; \
        /usr/bin/timedatectl set-timezone  Asia/Taipei; \
        #service dbus stop; \
	cat /dev/null > /var/run/utmp; \

        dpkg --configure -a; \
	bash -c "if [ ! -e /usr/lib/apt/methods/https ]; then ln -snf /root/Downloads/https /usr/lib/apt/methods/https; fi"; \

        apt-get -y update; \
        apt-get -y --force-yes upgrade; \

        apt-get -y install \
                ant ant-optional asciidoc autoconf automake autopoint autotools-dev \
                bison build-essential bzip2 \
                ccache cluster-glue cmake corosync-dev cvs; \

	cd /root/Downloads; \
	dpkg -i /root/Downloads/cgroup-lite_1.9_all.deb
