FROM robotica/xlbase:latest
RUN mkdir -p /addfiles/packages_pcmk; \
	mkdir -p /root/pcmk; \
	mkdir -p /addfiles/resource_pcmk
ADD ./debs/ /addfiles/packages_pcmk
ADD ./helper_scripts /usr/sbin
ADD ./defaults/corosync.conf /etc/corosync/
ADD ./functions /lib/lsb/init-functions
ADD ./util/* /root/pcmk/
RUN bash /addfiles/packages_pcmk/do.sh; \
	cp /addfiles/resource_pcmk/xlstatus /etc/init.d; \
	cp /addfiles/resource_pcmk/launcher /etc/init.d; \
	apt-get -y update; apt-get -y upgrade; \
	mkdir -p /root/pcsds; mkdir -p /etc/rc.d/init.d/; \
	ln -s /lib/lsb/init-functions /etc/rc.d/init.d/functions; \
  cd /root/pcmk; \
  git init; \
  git remote add -f origin https://github.com/ingted/xlbase.git; \
  git config core.sparseCheckout true; \
  echo "cluster/*" >> .git/info/sparse-checkout; \
  echo "monqodb/*" >> .git/info/sparse-checkout; \
  echo "mgmt/*" >> .git/info/sparse-checkout; \
  echo "alias/*" >> .git/info/sparse-checkout; \
  git checkout --track -b backToOrigin origin/backToOrigin
ADD ./pcsd /root/pcsds
