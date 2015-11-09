FROM robotica/xlbase:0.5.3
ADD ./debs/do.sh /root/debs/do.sh
ADD ./debs/grub2-common_2.02~beta2-9ubuntu1.3_amd64.deb /root/debs/grub2-common_2.02~beta2-9ubuntu1.3_amd64.deb
ADD ./debs/grub-common_2.02~beta2-9ubuntu1.3_amd64.deb /root/debs/grub-common_2.02~beta2-9ubuntu1.3_amd64.deb
ADD ./debs/grub-gfxpayload-lists_0.6_amd64.deb /root/debs/grub-gfxpayload-lists_0.6_amd64.deb
ADD ./debs/grub-pc_2.02~beta2-9ubuntu1.3_amd64.deb /root/debs/grub-pc_2.02~beta2-9ubuntu1.3_amd64.deb
ADD ./debs/grub-pc-bin_2.02~beta2-9ubuntu1.3_amd64.deb /root/debs/grub-pc-bin_2.02~beta2-9ubuntu1.3_amd64.deb
ADD ./debs/libaudit1_2.4.4-4ubuntu1_amd64.deb /root/debs/libaudit1_2.4.4-4ubuntu1_amd64.deb
ADD ./debs/libaudit-common_2.4.4-4ubuntu1_all.deb /root/debs/libaudit-common_2.4.4-4ubuntu1_all.deb
ADD ./debs/libauparse0_2.4.4-4ubuntu1_amd64.deb /root/debs/libauparse0_2.4.4-4ubuntu1_amd64.deb
ADD ./debs/libselinux1_2.3-2_amd64.deb /root/debs/libselinux1_2.3-2_amd64.deb
ADD ./debs/libselinux1-dev_2.3-2_amd64.deb /root/debs/libselinux1-dev_2.3-2_amd64.deb
ADD ./debs/libsepol1_2.3-2_amd64.deb /root/debs/libsepol1_2.3-2_amd64.deb
ADD ./debs/libsepol1-dev_2.3-2_amd64.deb /root/debs/libsepol1-dev_2.3-2_amd64.deb
ADD ./debs/python-audit_2.4.4-4ubuntu1_amd64.deb /root/debs/python-audit_2.4.4-4ubuntu1_amd64.deb
ADD ./debs/python-ipy_0.83-1_all.deb /root/debs/python-ipy_0.83-1_all.deb
ADD ./debs/python-selinux_2.3-2_amd64.deb /root/debs/python-selinux_2.3-2_amd64.deb
ADD ./debs/python-semanage_2.3-1build1_amd64.deb /root/debs/python-semanage_2.3-1build1_amd64.deb
ADD ./debs/selinux-utils_2.3-2build1_amd64.deb /root/debs/selinux-utils_2.3-2build1_amd64.deb
RUN apt-get -y update; apt-get -y upgrade; \
	dpkg -i /root/debs/*.deb; \
	/root/debs/do.sh
ADD ./helper_scripts /usr/sbin
ADD ./pcsd.sh /root/pcsd.sh
ADD ./defaults/corosync.conf /etc/corosync/
RUN mkdir -p /root/pcsds; mkdir -p /etc/rc.d/init.d/
ADD ./functions /lib/lsb/init-functions
RUN mkdir -p /etc/rc.d/init.d/; ln -s /lib/lsb/init-functions /etc/rc.d/init.d/functions
ADD ./pcsd /root/pcsds
RUN cp /root/pcsds/* /usr/share/pcsd -f
