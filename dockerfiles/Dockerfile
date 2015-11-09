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

RUN sed -i.bak -e s/exit\ 101/exit\ 0/g /usr/sbin/policy-rc.d; \
	ln -s /bin/true /etc/init.d/systemd-logind; \
	mkdir -p /root/Downloads; mkdir -p /root/Sources; \
        apt-get purge openjdk-7-*; \
        apt-get purge openjdk-8-*; \
	echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections; \
        echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections; \
        apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D; \
	rm /var/lib/apt/lists/* -vrf; \

#RUN mkdir -p /proc/sys/fs/binfmt_misc; \
#	chmod +w /proc/sys/fs/binfmt_misc; \
#	ls -l /proc/sys/fs/|grep binfmt_misc ; \
	apt-get -y update; \
	apt-get -y install apt-transport-https dbus binfmt-support llvm || true; \
	ls -l /usr/lib/apt/methods/https; \
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

RUN mkdir -p /etc/my_init.d; \
	 mkdir -p /docker_scripts
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

RUN cat /dev/null > /var/run/utmp; \
	ln -snf /root/Downloads/https /usr/lib/apt/methods/https; \
#	dpkg -i --force-confmiss /root/Downloads/plymouth_0.9.0-9_amd64.deb; \
#       dpkg -i --force-confmiss /root/Downloads/udev_215-17+deb8u1_amd64.deb; \
	sed -i.bak -e s/BEGIN\ INIT\ INFO/BEGIN\ INIT\ INFO\\\nexit\ 0\\\n/g  /etc/init.d/udev; \
	sed -i.bak -e s/USA/USA\\\nexit\ 0\\\n/g   /usr/sbin/invoke-rc.d; \
	dpkg --configure -a; \
#	apt-get -y update; \
	apt-get -y install udev; \
#	mv /etc/init.d/udev.bak /etc/init.d/udev; \
#	mv /usr/sbin/invoke-rc.d.bak /usr/sbin/invoke-rc.d
	apt-get -y update; \
	apt-get -y upgrade; \

	apt-get -y install \
        ant ant-optional asciidoc autoconf automake autopoint autotools-dev \
        bison build-essential bzip2 \
        ccache cluster-glue cmake corosync-dev cvs

ADD ./cgroup-lite_1.9_all.deb /root/Downloads/cgroup-lite_1.9_all.deb
RUN dpkg -i /root/Downloads/cgroup-lite_1.9_all.deb; \

	apt-get -y install \
        dbtoepub dbus docbook docbook-dsssl docbook-dsssl-doc docbook-xml docbook-xsl docker.io dsniff \
        flex \
        g++ gcc gdb gettext git git-arch git-completion git-core git-doc git-email git-svn \
        intltool \
        jade; \
	apt-get -y install \
        kernel-package \
        libaio1 libaio-dev libboost-all-dev libbz2-dev libc++1 libc++abi1 libc++abi-dev libc++abi-test \
                libc++-dev libc++-helpers libc++-test libc6 libc6-dbg libcluster-glue-dev libcurl4-gnutls-dev \
                #libcurl4-openssl-dev 
		libdbus-1-dev libdbus-glib-1-dev libesmtp-dev libgdbm-dev \
                libglib2.0-dev libncurses5-dev libpam0g-dev libpe-status4 libpod-2-docbook-perl libqb-dev \
                libreadline-dev libselinux-dev libsgml-dtdparse-perl libsnmp-base libsnmp-dev libsqlite3-dev \
                libssl-dev libtool libxml2-dev libxml2-utils libxslt1-dev llvm; \
	apt-get -y install \
        lm-sensors \
        multiarch-support \
        ncurses-dev ntp \
	openjade1.3 opensp \
	#oracle-java7-installer oracle-java8-installer \
        p7zip p7zip-full pbzip2 pkg-config publican python-lxml; \

	apt-get -y install \
	#libsystemd-dev 
	libtool; \

	apt-get -y install \
        python-software-properties python-pip python-dev python-pip python-dev \
        python3 python3-software-properties python-httplib2 python-setuptools \
        python3-dev python-lxml; \
	#python3-systemd

	apt-get -y install libmysqlclient-dev libmysql++6 libmysql++-dev libdbd-mysql-perl mysql-client; \

	apt-get -y install wget; \
	pip install requests[security]; \
	pip install pyopenssl ndg-httpsclient pyasn1; \
	wget "https://raw.github.com/pypa/pip/master/contrib/get-pip.py"; \
	wget https://bootstrap.pypa.io/ez_setup.py -O - | python; \
	python get-pip.py; \
        pip uninstall -y distribute || true; \
        pip uninstall -y setuptools || true; \
        pip install ipython; \
        pip install --upgrade ipython; \


	wget "http://launchpadlibrarian.net/173841617/init-system-helpers_1.18_all.deb"; \
        dpkg -i init-system-helpers_1.18_all.deb

WORKDIR /usr/lib/x86_64-linux-gnu/

RUN ln -sf ./libmysqlclient.so libmysqlclient_r.so; \
        ln -sf ./libmysqlclient.so.18 libmysqlclient_r.so.18; \



	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 10; \
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 10; \
	update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30; \
	update-alternatives --set cc /usr/bin/gcc; \
	update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30; \
	update-alternatives --set c++ /usr/bin/g++; \
	update-alternatives --config gcc; \
	update-alternatives --config g++; \
	mkdir -p /root/Downloads/pgxl; \
	mkdir -p /root/Downloads/pgxl95; \
	mkdir -p /root/Downloads/vdb

WORKDIR /root/Downloads/pgxl
RUN wget "http://sourceforge.net/projects/postgres-xl/files/Releases/Version_9.2rc/postgres-xl-v9.2-src.tar.gz"

ADD ./stormstats.c /root/Downloads/pgxl95/stormstats.c

WORKDIR /root/Downloads/pgxl95
RUN git clone git://git.postgresql.org/git/postgres-xl.git; \
	cp /root/Downloads/pgxl95/stormstats.c /root/Downloads/pgxl95/postgres-xl/contrib/stormstats/

WORKDIR /root/Downloads/pgxl95/postgres-xl/
RUN ln -s /usr/bin/make /usr/bin/gmake; \
	 export OSX=/usr/bin/osx; \
	./configure --with-python; \
	gmake world -j8; \

	apt-get -y install monodevelop; \
	mkdir -p /root/Downloads/fs; \
	mkdir -p /root/Downloads/clusterLab/libqb; \
	mkdir -p /root/Downloads/clusterLab/corosync; \
	mkdir -p /root/Downloads/clusterLab/cluster-glue; \
	mkdir -p /root/Downloads/clusterLab/resource-agents; \
	mkdir -p /root/Downloads/clusterLab/pacemaker; \
	mozroots --import --sync

WORKDIR /root/Downloads/fs
RUN pwd; \
	rm fsharp -f; \
	git clone https://github.com/fsharp/fsharp.git; \
	cd fsharp; \
	mkdir -p .paket
	
ADD ./paket.bootstrapper.exe /root/Downloads/fs/fsharp/.paket/paket.bootstrapper.exe
ADD ./paket.dependencies /root/Downloads/fs/fsharp/paket.dependencies

WORKDIR /root/Downloads/fs/fsharp/.paket/
RUN mono paket.bootstrapper.exe; \
	mono paket.exe update

WORKDIR /root/Downloads/fs/fsharp/
RUN ./autogen.sh --prefix=/usr; \
        make


#	echo "none  /proc/sys/fs/binfmt_misc binfmt_misc defaults 0 0" >> /etc/fstab; \
#	chmod +x /root/Downloads/fs/fsharp/src/fsharp/fsi/obj/release/fsi.exe

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


WORKDIR /root/Downloads/clusterLab/libqb
RUN wget "https://github.com/ClusterLabs/libqb/archive/v0.17.2.tar.gz"; \
	tar xpvf ./v0.17.2.tar.gz; \
	cd libqb-0.17.2; \
	./autogen.sh; \
	./configure; \
	make; \

	apt-get -y install software-properties-common; \
	cat > /etc/apt/sources.list.d/webupd8team-java.list << EOF \
		deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main \
		deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main \
	EOF; \
	add-apt-repository -y ppa:webupd8team/java; \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886; \
	apt-get update; \
	apt-get -y install oracle-java8-installer oracle-java7-installer vim; \
	useradd --system -U -ms /bin/bash postgres; \
	useradd --system -U -ms /bin/bash osdba; \
	useradd --system -U -ms /bin/bash voltdb; \
	sed -i.bak -e s/postgres\:\!/postgres\:\$6\$H1W8BGOe\$zue0LuGmqohKdjJiF1GCKD7r3XuJWniuqXfavfoLSUmH9FdkGZi9maI597swe0AkiMJuoxLO9PbuwH8Le6aEq1/g /etc/shadow; \
	sed -i.bak -e s/osdba\:\!/postgres\:\$6\$H1W8BGOe\$zue0LuGmqohKdjJiF1GCKD7r3XuJWniuqXfavfoLSUmH9FdkGZi9maI597swe0AkiMJuoxLO9PbuwH8Le6aEq1/g /etc/shadow; \ 
	sed -i.bak -e s/voltdb\:\!/postgres\:\$6\$H1W8BGOe\$zue0LuGmqohKdjJiF1GCKD7r3XuJWniuqXfavfoLSUmH9FdkGZi9maI597swe0AkiMJuoxLO9PbuwH8Le6aEq1/g /etc/shadow; 

ADD ./bashrc_4_xl /root/Downloads/pgxl95/bashrc_4_xl
RUN cat /root/Downloads/pgxl95/bashrc_4_xl >> ~/.bashrc; \
	mkdir -p /root/Downloads/clusterLab/corosync

WORKDIR /root/Downloads/clusterLab/corosync
RUN wget "https://github.com/corosync/corosync/archive/v2.3.5.tar.gz"; \
	apt-get -y update; \
	apt-get -y install libnss3-dev groff; \
	tar zxvf ./v2.3.5.tar.gz; \
	cd corosync-2.3.5; \
	./autogen.sh; \
	./configure; \
	make -j8 


#RUN mkdir -p /root/Downloads/clusterLab/cluster-glue
WORKDIR /root/Downloads/clusterLab/cluster-glue

RUN apt-get -y install mercurial uuid-dev; \

	hg clone http://hg.linux-ha.org/glue cluster-glue; \
	#ls -l /root/Downloads/clusterLab/cluster-glue; \
	#ls -l /root/Downloads/clusterLab; \
	cd cluster-glue; \
	./autogen.sh; \
	./configure --enable-fatal-warmings=yes; \
	make -j8; \


	mkdir -p /root/Downloads/clusterLab/resource-agents; \
	mkdir -p /root/Downloads/clusterLab/crmsh; \
	mkdir -p /root/Downloads/clusterLab/pcs; \
	apt-get -y install snmpd pacemaker-mgmt cluster-glue-dev
	 
	
WORKDIR /root/Downloads/clusterLab/resource-agents
#RUN wget "https://github.com/ClusterLabs/resource-agents/archive/v3.9.6.tar.gz"; \
RUN git clone https://github.com/ClusterLabs/resource-agents.git; \
	#tar xzvf v3.9.6.tar.gz; \
	#cd resource-agents-3.9.6; \
	cd resource-agents; \
	./autogen.sh; \
	./configure; \
	make


WORKDIR /root/Downloads/clusterLab/crmsh
RUN wget "https://github.com/ClusterLabs/crmsh/archive/2.1.0.tar.gz"; \
	tar zxvf 2.1.0.tar.gz; \
	cd crmsh-2.1.0; \ 
	./autogen.sh; \
	./configure; \
	make



WORKDIR /root/Downloads/clusterLab/pcs
RUN wget "https://github.com/ClusterLabs/pcs/archive/0.9.141.tar.gz"; \
	tar zxvf 0.9.141.tar.gz; \
	ls -l; \
	ls -l pcs-0.9.141; \
	cd pcs-0.9.141/pcsd; \
	make get_gems; \
	cd ..
	#make install (normal install)
	#make install_pcsd


RUN mkdir -p /root/Downloads/clusterLab/fence-agents; \
	mkdir -p /root/Downloads/clusterLab/hawk

WORKDIR /root/Downloads/clusterLab/fence-agents
RUN wget "https://github.com/ClusterLabs/fence-agents/archive/v4.0.21.tar.gz"; \
	apt-get -y install python-suds
RUN	tar xzvf v4.0.21.tar.gz; \
	cd fence-agents-4.0.21; \
	./autogen.sh; \
	./configure; \
	make
	
WORKDIR /root/Downloads/clusterLab/hawk
RUN wget "https://github.com/ClusterLabs/hawk/archive/1.0.0-alpha1.tar.gz"; \
	tar zxvf 1.0.0-alpha1.tar.gz; \
	cd hawk-1.0.0-alpha1; \
	apt-get -y install pacemaker-dev libreadline-gplv2-dev graphviz libgraphviz-dev ttf-dejavu fonts-dejavu


WORKDIR /root/Downloads/clusterLab/pacemaker
RUN wget "https://github.com/ClusterLabs/pacemaker/archive/Pacemaker-1.1.13-rc3.tar.gz"; \
	apt-get -y install rpm; \
 
	tar xzvf Pacemaker-1.1.13-rc3.tar.gz; \
	cd pacemaker-Pacemaker-1.1.13-rc3; \
	./autogen.sh; \
	./configure; \
	make

###### Upgrading the operating system inside the container
#
#Baseimage-docker images contain an Ubuntu 14.04 operating system.
#
#While we release Baseimage-docker images with the latest OS updates from time to time, you do not have to rely on us.
#You can update the OS inside Baseimage-docker images yourself, and it is recommend that you do this instead of waiting for us.
#
#To upgrade the OS in the image, run this in your Dockerfile:
#
#  RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

###### Adding daemons
#In Dockerfile:
#
#  RUN mkdir /etc/service/memcached
#  ADD memcached.sh /etc/service/memcached/run
#
#In memcached.sh (make sure this file is chmod +x):
#
#  !/bin/sh
#  #`/sbin/setuser memcache` runs the given command as the user `memcache`.
#  #If you omit that part, the command will be run as root.
#
#  exec /sbin/setuser memcache /usr/bin/memcached >>/var/log/memcached.log 2>&1

###### A correct init process
#/sbin/my_init that reaps orphaned child processes correctly, and responds to SIGTERM correctly.
#It runs the following scripts during startup, in the following order:
#All executable scripts in /etc/my_init.d, if this directory exists. The scripts are run in lexicographic order.
#The script /etc/rc.local, if this file exists.
#All scripts must exit correctly, e.g. with exit code 0. If any script exits with a non-zero exit code, the booting will fail.
#
#In logtime.sh (make sure this file is chmod +x):
#
#  #!/bin/sh
#  date > /tmp/boottime.txt
#
#In Dockerfile:
#
#  RUN mkdir -p /etc/my_init.d
#  ADD logtime.sh /etc/my_init.d/logtime.sh
#

###### Before any script loaded, my_init imports environment variables from the directory /etc/container_environment
#
#In Dockerfile:
#
#  RUN echo Apachai Hopachai > /etc/container_environment/MY_NAME
#
#You can verify that it works, as follows:
#
#  $ docker run -t -i <YOUR_NAME_IMAGE> /sbin/my_init -- bash -l
#  ...
#  *** Running bash -l...
#  echo $MY_NAME
#  Apachai Hopachai
#
#Handling newlines
#
#If you've looked carefully, you'll notice that the 'echo' command actually prints a newline.
#Why does $MY_NAME not contain a newline then?
#It's because my_init strips the trailing newline, if any.
#If you intended on the value having a newline, you should add another newline, like this:
#
#  RUN echo -e "Apachai Hopachai\n" > /etc/container_environment/MY_NAME

###### Environment variable dumps
#
#During startup, after importing environment variables from /etc/container_environment, my_init will dump all its environment variables
#(that is, all variables imported from container_environment, as well as all variables it picked up from docker run --env)
#to the following locations, in the following formats:
#
#  /etc/container_environment
#  /etc/container_environment.sh - a dump of the environment variables in Bash format. You can source the file directly from a Bash shell script.
#  /etc/container_environment.json - a dump of the environment variables in JSON format.



###### Security
#
#/etc/container_environment and its Bash and JSON dumps are by default owned by root, and accessible only by the docker_env group
#(so that any user added this group will have these variables automatically loaded).
#
#If you are sure that your environment variables don't contain sensitive data, then you can also relax the permissions on that directory and those files by making them world-readable:
#
#  RUN chmod 755 /etc/container_environment
#  RUN chmod 644 /etc/container_environment.sh /etc/container_environment.json


RUN chmod 755 /etc/container_environment; \
	echo "\[\e]0;\u@\$(hostname):\ \w\a\]${debian_chroot:+(\$debian_chroot)}\[\033[01;36m\]\u@\$(hostname)\[\033[00m\]:\[\033[01;32m\]\w\[\033[00m\]\\\$ " > /etc/container_environment/PS1; \
###### Fixes APT incompatibilities with Docker

###### syslog-ng
#It runs a syslog daemon so that important system messages don't get lost.

###### cron daemon
#It runs a cron daemon so that cronjobs work.

###### SSH server
#Allows you to easily login to your container to inspect or administer things.
#SSH is only one of the methods provided by baseimage-docker for this purpose.
#
#Baseimage-docker disables the SSH server by default. Add the following to your Dockerfile to enable it:

	rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
#
#  RUN /etc/my_init.d/00_regen_ssh_host_keys.sh


###### About SSH keys
#
#Ensure that you have the right SSH keys installed inside the container. By default, no keys are installed, so nobody can login.
#For convenience reasons, we provide a pregenerated, insecure key (PuTTY format) that you can easily enable.
#However, please be aware that using this key is for convenience only. It does not provide any security because this key is publicly available
#In production environment, you should use your own keys.
#
#Using the insecure key for one container only
#
#You can temporarily enable the insecure key for one container only. This means that the insecure key is installed at container boot.
#If you docker stop and docker start the container, the insecure key will still be there, but if you use docker run to start a new container then that container will not contain the insecure key.
#
#Start a container with --enable-insecure-key:
#
#  docker run YOUR_IMAGE /sbin/my_init --enable-insecure-key
#
#Find out the ID of the container that you just ran:
#
#  docker ps
#
#Once you have the ID, look for its IP address with:
#
#  docker inspect -f "{{ .NetworkSettings.IPAddress }}" <ID>
#
#Now that you have the IP address, you can use SSH to login to the container, or to execute a command inside it:

###### Download the insecure private key
#
#  curl -o insecure_key -fSL https://github.com/phusion/baseimage-docker/raw/master/image/services/sshd/keys/insecure_key
#  chmod 600 insecure_key
#
#Login to the container
#
#  ssh -i insecure_key root@<IP address>
#
#Running a command inside the container
#
#  ssh -i insecure_key root@<IP address> echo hello world
#
#Enabling the insecure key permanently
#It is also possible to enable the insecure key in the image permanently. This is not generally recommended,
#but is suitable for e.g. temporary development or demo environments where security does not matter.
#
#Edit your Dockerfile to install the insecure key permanently:
#
#  RUN /usr/sbin/enable_insecure_key
#
#Instructions for logging in the container is the same as in section Using the insecure key for one container only.


######Using your own key
#
#Edit your Dockerfile to install an SSH public key:
#
#Install an SSH of your choice.
#
#  ADD your_key.pub /tmp/your_key.pub
#  RUN cat /tmp/your_key.pub >> /root/.ssh/authorized_keys && rm -f /tmp/your_key.pub
#
#Then rebuild your image. Once you have that, start a container based on that image:
#
#  docker run your-image-name
#
#Find out the ID of the container that you just ran:
#
#  docker ps
#
#Once you have the ID, look for its IP address with:
#
#  docker inspect -f "{{ .NetworkSettings.IPAddress }}" <ID>
#
#Now that you have the IP address, you can use SSH to login to the container, or to execute a command inside it:

###### Login to the container
#
#  ssh -i /path-to/your_key root@<IP address>
#
#Running a command inside the container
#
#  ssh -i /path-to/your_key root@<IP address> echo hello world

######  The docker-ssh tool
#
#Looking up the IP of a container and running an SSH command quickly becomes tedious.
#Luckily, we provide the docker-ssh tool which automates this process.
#This tool is to be run on the Docker host, not inside a Docker container.
#
#First, install the tool on the Docker host:
#
#  curl --fail -L -O https://github.com/phusion/baseimage-docker/archive/master.tar.gz && \
#  tar xzf master.tar.gz && \
#  sudo ./baseimage-docker-master/install-tools.sh
#
#Then run the tool as follows to login to a container using SSH:
#
#  docker-ssh YOUR-CONTAINER-ID
#
#You can lookup YOUR-CONTAINER-ID by running docker ps.
#By default, docker-ssh will open a Bash session. You can also tell it to run a command, and then exit:
#
#  docker-ssh YOUR-CONTAINER-ID echo hello world


###### runit
#
#Used for service supervision and management. Much easier to use than SysV init and supports restarting daemons when they crash. Much easier to use and more lightweight than Upstart.

#Baseimage-docker encourages you to run multiple processes through the use of runit.
#Baseimage-docker encourages you to run multiple processes through the use of runit.
#
#You might be familiar with supervisord. Runit (written in C) is much lighter weight than supervisord (written in Python).

###### setuser
#
#A custom tool for running a command as another user. Easier to use than su,
#has a smaller attack vector than sudo,
#and unlike chpst this tool sets $HOME correctly.
#Available as /sbin/setuser.

WORKDIR /root/Downloads/clusterLab/libqb/libqb-0.17.2
RUN make install

WORKDIR /root/Downloads/clusterLab/corosync/corosync-2.3.5
RUN make install


WORKDIR /root/Downloads/clusterLab/cluster-glue/cluster-glue
RUN make install


WORKDIR /root/Downloads/clusterLab/resource-agents/resource-agents
RUN rm /usr/lib/ocf/resource.d/heartbeat/.ocf-binaries -f; \
	rm /usr/lib/ocf/resource.d/heartbeat/.ocf-returncodes -f; \
	rm /usr/lib/ocf/resource.d/heartbeat/.ocf-directories -f; \
	rm /usr/lib/ocf/resource.d/heartbeat/.ocf-shellfuncs -f; \
	make install

WORKDIR /root/Downloads/clusterLab/pacemaker/pacemaker-Pacemaker-1.1.13-rc3
RUN make install

ADD ./bashrc_4_ps1 /root/Downloads/pgxl95/bashrc_4_ps1


WORKDIR /root/Downloads/clusterLab/pcs/pcs-0.9.141
RUN apt-get -y install ruby-dev; \
	make; \
	cd pcsd; \
	gem install eventmachine -v '1.0.7'; \
	gem install bundler; \
	make get_gems; \
	cd ..; \
	make install; \
	make install_pcsd install_settings=true; \

	mv /etc/init.d/udev.bak /etc/init.d/udev; \
	mv /usr/sbin/invoke-rc.d.bak /usr/sbin/invoke-rc.d; \
	mv /usr/local/lib/libgpg-error.so.0 /usr/local/lib/libgpg-error.so.0.bak; \
	ln -s /lib/x86_64-linux-gnu/libgpg-error.so.0 /usr/local/lib/; \
	bash -c 'echo "postgres ALL=(ALL)    ALL" >> /etc/sudoers'; \	
	bash -c 'echo "osdba ALL=(ALL)    ALL" >> /etc/sudoers'; \	
	bash -c 'echo "voltdb ALL=(ALL)    ALL" >> /etc/sudoers'; \	
	apt-get clean; \
	rm -rf /tmp/* /var/tmp/*; \
	rm -rf /var/lib/apt/lists/*; \
	echo xlbase > /whoami; \
	cat /root/Downloads/pgxl95/bashrc_4_ps1 >> ~/.bashrc; \
	history -c; \
	bash -c 'echo  "export HOME=/root/" >> /root/.bashrc'

#$ make install install_settings=true
#$ cd pcsd/ && make get_gems
#$ cd ../ && make install_pcsd install_settings=true


# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
