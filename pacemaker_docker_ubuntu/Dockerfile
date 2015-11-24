FROM robotica/xlbase:0.6.4-no-pcmk
ADD ./debs/ /addfiles/packages_pcmk
ADD ./helper_scripts /usr/sbin
ADD ./pcsd.sh /root/pcsd.sh
ADD ./defaults/corosync.conf /etc/corosync/
ADD ./functions /lib/lsb/init-functions
RUN bash /addfiles/packages_pcmk/do.sh; \
	apt-get -y update; apt-get -y upgrade; \
	mkdir -p /root/pcsds; mkdir -p /etc/rc.d/init.d/; \
	ln -s /lib/lsb/init-functions /etc/rc.d/init.d/functions
ADD ./pcsd /root/pcsds
