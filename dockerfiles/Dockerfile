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

RUN ln -snf /bin/bash /bin/sh

ENV DEBIAN_FRONTEND noninteractive 
###apt-get autoremove

ADD ./docker.list /etc/apt/sources.list.d/
ADD ./sources.list /etc/apt/

RUN sed -i.bak -e s/exit\ 101/exit\ 0/g /usr/sbin/policy-rc.d
RUN ln -s /bin/true /etc/init.d/systemd-logind

RUN mkdir -p /root/Downloads; mkdir -p /root/Sources; \
        apt-get purge openjdk-7-*; \
        apt-get purge openjdk-8-*; \
	echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections; \
        echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections; \
        apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D


RUN rm /var/lib/apt/lists/* -vrf

#RUN mkdir -p /proc/sys/fs/binfmt_misc; \
#	chmod +w /proc/sys/fs/binfmt_misc; \
#	ls -l /proc/sys/fs/|grep binfmt_misc ; \
RUN apt-get -y update; \
	apt-get -y install apt-transport-https dbus binfmt-support llvm || true

RUN ls -l /usr/lib/apt/methods/https; \
	cp /usr/lib/apt/methods/https /root/Downloads/https; \
	ln -snf /root/Downloads/https /usr/lib/apt/methods/https

ADD ./libsystemd.so.0 /lib/x86_64-linux-gnu/libsystemd.so.0
ADD ./libcap-ng.so.0 /usr/lib/x86_64-linux-gnu/libcap-ng.so.0
ADD ./libgcrypt.so.20 /lib/x86_64-linux-gnu/libgcrypt.so.20

ADD ./timedatectl 		/usr/bin/
ADD ./dbus-cleanup-sockets  	/usr/bin/dbus-cleanup-sockets
ADD ./dbus-daemon           	/usr/bin/dbus-daemon
ADD ./dbus-launch           	/usr/bin/dbus-launch
ADD ./dbus-monitor          	/usr/bin/dbus-monitor
ADD ./dbus-run-session      	/usr/bin/dbus-run-session
ADD ./dbus-send             	/usr/bin/dbus-send
ADD ./dbus-uuidgen          	/usr/bin/dbus-uuidgen

RUN mkdir -p /etc/my_init.d
RUN mkdir -p /docker_scripts
ADD ./110_logtime.sh /etc/my_init.d/110_logtime.sh

RUN rm /etc/rc.local
ADD ./rc.local /etc/rc.local

#ADD ./120_dbus.sh /etc/my_init.d/120_dbus.sh
ADD ./120_dbus.sh.old /docker_scripts/120_dbus.sh

RUN /docker_scripts/120_dbus.sh; \
	service dbus status; \
	/usr/bin/timedatectl set-timezone  Asia/Taipei; \
	service dbus stop

WORKDIR /root/Downloads

RUN apt-get -y purge \
        libcurl3 libcurl3-gnutls

#RUN ls -l /usr/lib/apt/methods/https

ADD ./libgmp.so.10 /usr/lib/x86_64-linux-gnu/libgmp.so.10
ADD ./libcurl-gnutls.so.4 /usr/lib/x86_64-linux-gnu/libcurl-gnutls.so.4
ADD ./librtmp.so.1 /usr/lib/x86_64-linux-gnu/librtmp.so.1
ADD ./libssh2.so.1 /usr/lib/x86_64-linux-gnu/libssh2.so.1
ADD ./libnettle.so.4 /usr/lib/x86_64-linux-gnu/libnettle.so.4
ADD ./libgnutls-deb0.so.28 /usr/lib/x86_64-linux-gnu/libgnutls-deb0.so.28
ADD ./libhogweed.so.2 /usr/lib/x86_64-linux-gnu/libhogweed.so.2
#ADD ./udev_215-17+deb8u1_amd64.deb /root/Downloads/udev_215-17+deb8u1_amd64.deb
#ADD ./plymouth_0.9.0-9_amd64.deb /root/Downloads/plymouth_0.9.0-9_amd64.deb

#RUN apt-get -y install udev

RUN cat /dev/null > /var/run/utmp
RUN ln -snf /root/Downloads/https /usr/lib/apt/methods/https; \
#	dpkg -i --force-confmiss /root/Downloads/plymouth_0.9.0-9_amd64.deb; \
#       dpkg -i --force-confmiss /root/Downloads/udev_215-17+deb8u1_amd64.deb; \
	sed -i.bak -e s/BEGIN\ INIT\ INFO/BEGIN\ INIT\ INFO\\\nexit\ 0\\\n/g  /etc/init.d/udev; \
	sed -i.bak -e s/USA/USA\\\nexit\ 0\\\n/g   /usr/sbin/invoke-rc.d; \
	dpkg --configure -a; \
#	apt-get -y update; \
	apt-get -y install udev; \
#	mv /etc/init.d/udev.bak /etc/init.d/udev; \
#	mv /usr/sbin/invoke-rc.d.bak /usr/sbin/invoke-rc.d
RUN apt-get -y update; \
	apt-get -y upgrade

RUN apt-get -y install \
        ant ant-optional asciidoc autoconf automake autopoint autotools-dev \
        bison build-essential bzip2 \
        ccache cluster-glue cmake corosync-dev cvs

ADD ./cgroup-lite_1.9_all.deb /root/Downloads/cgroup-lite_1.9_all.deb
RUN dpkg -i /root/Downloads/cgroup-lite_1.9_all.deb

RUN apt-get -y install \
        dbtoepub dbus docbook docbook-dsssl docbook-dsssl-doc docbook-xml docbook-xsl docker.io dsniff \
        flex \
        g++ gcc gdb gettext git git-arch git-completion git-core git-doc git-email git-svn \
        intltool \
        jade 
RUN apt-get -y install \
        kernel-package \
        libaio1 libaio-dev libboost-all-dev libbz2-dev libc++1 libc++abi1 libc++abi-dev libc++abi-test \
                libc++-dev libc++-helpers libc++-test libc6 libc6-dbg libcluster-glue-dev libcurl4-gnutls-dev \
                #libcurl4-openssl-dev 
		libdbus-1-dev libdbus-glib-1-dev libesmtp-dev libgdbm-dev \
                libglib2.0-dev libncurses5-dev libpam0g-dev libpe-status4 libpod-2-docbook-perl libqb-dev \
                libreadline-dev libselinux-dev libsgml-dtdparse-perl libsnmp-base libsnmp-dev libsqlite3-dev \
                libssl-dev libtool libxml2-dev libxml2-utils libxslt1-dev llvm 
RUN apt-get -y install \
        lm-sensors \
        multiarch-support \
        ncurses-dev ntp \
	openjade1.3 opensp \
	#oracle-java7-installer oracle-java8-installer \
        p7zip p7zip-full pbzip2 pkg-config publican python-lxml

RUN apt-get -y install \
	#libsystemd-dev 
	libtool

RUN apt-get -y install \
        python-software-properties python-pip python-dev python-pip python-dev \
        python3 python3-software-properties python-httplib2 python-setuptools \
        python3-dev python-lxml 
	#python3-systemd

RUN apt-get -y install libmysqlclient-dev libmysql++6 libmysql++-dev libdbd-mysql-perl mysql-client

RUN apt-get -y install wget; \
	pip install requests[security]; \
	pip install pyopenssl ndg-httpsclient pyasn1; \
	wget "https://raw.github.com/pypa/pip/master/contrib/get-pip.py"
RUN wget https://bootstrap.pypa.io/ez_setup.py -O - | python; \
	python get-pip.py; \
        pip uninstall -y distribute || true; \
        pip uninstall -y setuptools || true; \
        pip install ipython; \
        pip install --upgrade ipython


RUN wget "http://launchpadlibrarian.net/173841617/init-system-helpers_1.18_all.deb"; \
        dpkg -i init-system-helpers_1.18_all.deb

WORKDIR /usr/lib/x86_64-linux-gnu/

RUN ln -sf ./libmysqlclient.so libmysqlclient_r.so; \
        ln -sf ./libmysqlclient.so.18 libmysqlclient_r.so.18


#RUN mkdir /etc/service/dbus
#ADD 120_dbus.sh /etc/service/dbus/run
#RUN chmod +x /etc/service/dbus/run; \
#	chmod +x /docker_scripts/120_dbus.sh
#RUN chmod +x /docker_scripts/120_dbus.sh

#RUN service stop dbus || true; \
#	if [ -e /var/run/dbus/system_bus_socket ]; then \
#		rm /var/run/dbus/system_bus_socket; \
#	fi
#RUN /docker_scripts/120_dbus.sh start; \
#RUN service dbus status; \
#
#RUN	/usr/bin/timedatectl set-timezone  Asia/Taipei 
#RUN /docker_scripts/120_dbus.sh stop || true; \
#	if [ -e /var/run/dbus/system_bus_socket ]; then \
#		rm /var/run/dbus/system_bus_socket; \
#	fi

#RUN apt-get -y install g++-5


# Use baseimage-docker's init system.

CMD ["/sbin/my_init"]
