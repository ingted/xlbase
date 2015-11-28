FROM robotica/xlbase:latest
RUN mkdir -p /addfiles/packages_pcmk
ADD ./debs/ /addfiles/packages_pcmk
ADD ./helper_scripts /usr/sbin
ADD ./pcsd.sh /root/pcsd.sh
ADD ./defaults/corosync.conf /etc/corosync/
ADD ./functions /lib/lsb/init-functions
RUN bash /addfiles/packages_pcmk/do.sh; \
	apt-get -y update; apt-get -y upgrade; \
	mkdir -p /root/pcsds; mkdir -p /etc/rc.d/init.d/; \
	ln -s /lib/lsb/init-functions /etc/rc.d/init.d/functions; \
  mkdir -p /root/pcmk; \
  cd /root/pcmk; \
  git init; \
  git remote add -f origin https://github.com/ingted/xlbase.git; \
  git config core.sparseCheckout true; \
  echo "cluster/*" >> .git/info/sparse-checkout; \
  git checkout --track -b backToOrigin origin/backToOrigin
ADD ./pcsd /root/pcsds
