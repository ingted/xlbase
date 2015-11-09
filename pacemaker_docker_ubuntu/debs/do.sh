#!/bin/bash

#wget "http://mirrors.kernel.org/ubuntu/pool/main/g/grub2/grub-pc_2.02~beta2-9ubuntu1.3_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/main/g/grub2/grub-common_2.02~beta2-9ubuntu1.3_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/main/g/grub2/grub2-common_2.02~beta2-9ubuntu1.3_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/main/g/grub2/grub-pc-bin_2.02~beta2-9ubuntu1.3_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/main/g/grub-gfxpayload-lists/grub-gfxpayload-lists_0.6_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/main/a/audit/libaudit1_2.4.4-4ubuntu1_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/main/a/audit/libauparse0_2.4.4-4ubuntu1_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/main/a/audit/libaudit-common_2.4.4-4ubuntu1_all.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/main/libs/libselinux/libselinux1_2.3-2_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/main/libs/libselinux/libselinux1-dev_2.3-2_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/main/libs/libsepol/libsepol1-dev_2.3-2_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/main/libs/libsepol/libsepol1_2.3-2_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/universe/i/ipy/python-ipy_0.83-1_all.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/universe/libs/libselinux/selinux-utils_2.3-2build1_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/universe/a/audit/python-audit_2.4.4-4ubuntu1_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/universe/libs/libselinux/python-selinux_2.3-2_amd64.deb"
#wget "http://mirrors.kernel.org/ubuntu/pool/universe/libs/libsemanage/python-semanage_2.3-1build1_amd64.deb"

cd /root/debs

dpkg -i grub-pc_2.02~beta2-9ubuntu1.3_amd64.deb \
	grub-common_2.02~beta2-9ubuntu1.3_amd64.deb \
	grub2-common_2.02~beta2-9ubuntu1.3_amd64.deb \
	grub-pc-bin_2.02~beta2-9ubuntu1.3_amd64.deb \
	grub-gfxpayload-lists_0.6_amd64.deb \
	libaudit1_2.4.4-4ubuntu1_amd64.deb \
	libauparse0_2.4.4-4ubuntu1_amd64.deb \
	libaudit-common_2.4.4-4ubuntu1_all.deb \
	libselinux1_2.3-2_amd64.deb \
	libselinux1-dev_2.3-2_amd64.deb \
	libsepol1-dev_2.3-2_amd64.deb \
	libsepol1_2.3-2_amd64.deb \
	python-ipy_0.83-1_all.deb \
	selinux-utils_2.3-2build1_amd64.deb \
	python-audit_2.4.4-4ubuntu1_amd64.deb \
	python-selinux_2.3-2_amd64.deb \
	python-semanage_2.3-1build1_amd64.deb

apt-get -y install libapol4 libqpol1 policycoreutils
