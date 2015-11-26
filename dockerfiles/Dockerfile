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

################################################
###                                          ###
### If you want to upgrade to 16.04          ###
### Please execute:                          ###
###                                          ###
###   apt-get dist-upgrade                   ###
###   apt-get install update-manager-core    ###
###   do-release-upgrade -d                  ###
###                                          ###
################################################


ENV DEBIAN_FRONTEND noninteractive 

ADD ./addfiles /addfiles

#ADD ./addfiles/gnu/libgmp.so.10 \
#	./addfiles/gnu/libcurl-gnutls.so.4 \    
#	./addfiles/gnu/librtmp.so.1 \    
#	./addfiles/gnu/libssh2.so.1 \           
#	./addfiles/gnu/libnettle.so.4 \           
#	./addfiles/gnu/libgnutls-deb0.so.28 \     
#	./addfiles/gnu/libhogweed.so.2 \         
#	./addfiles/gnu/libcap-ng.so.0		/usr/lib/x86_64-linux-gnu/

RUN mkdir -p /addfiles; \
	mkdir -p /root/Downloads; \
	mkdir -p /root/Sources; \
	mkdir -p /etc/my_init.d; \
        mkdir -p /docker_scripts; \
	sed -i.bak -e s/USA/USA\\\nexit\ 0\\\n/g   /usr/sbin/invoke-rc.d; \
	sed -i.bak -e s/exit\ 101/exit\ 0/g /usr/sbin/policy-rc.d; \
	apt-get -y update; \
	#apt-get -y install apt-transport-https dbus binfmt-support llvm udev binutils libgmp-dev || true; \
	apt-get -y install apt-transport-https       binfmt-support llvm udev binutils libgmp-dev wget || true; \
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
	#cp /addfiles/packages 			/root/Downloads/ -rf; \
	cp /addfiles/gnu/libgmp.so.10 		/usr/lib/x86_64-linux-gnu/; \
	cp /addfiles/gnu/libcurl-gnutls.so.4    /usr/lib/x86_64-linux-gnu/; \  
	cp /addfiles/gnu/librtmp.so.1    	/usr/lib/x86_64-linux-gnu/; \ 
	cp /addfiles/gnu/libssh2.so.1           /usr/lib/x86_64-linux-gnu/; \  
	cp /addfiles/gnu/libnettle.so.4         /usr/lib/x86_64-linux-gnu/; \    
	cp /addfiles/gnu/libgnutls-deb0.so.28   /usr/lib/x86_64-linux-gnu/; \    
	cp /addfiles/gnu/libhogweed.so.2        /usr/lib/x86_64-linux-gnu/; \   
	cp /addfiles/gnu/libcap-ng.so.0		/usr/lib/x86_64-linux-gnu/; \
	cp -rf /addfiles/dbus-1			/usr/share/



RUN export DEBIAN_FRONTEND=noninteractive; \
	sed -i.bak -e s/exit\ 101/exit\ 0/g /usr/sbin/policy-rc.d; \
	ln -s /bin/true /etc/init.d/systemd-logind; \
 	ln -snf /root/Downloads/https /usr/lib/apt/methods/https; \
        apt-get purge openjdk-7-*; \
        apt-get purge openjdk-8-*; \
	echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections; \
        echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections; \
        apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D; \
	rm /var/lib/apt/lists/* -vrf; \
	#apt-get -y update

	cd /addfiles/mono_new; \

	dpkg -i libselinux1_2.3-2build1_amd64.deb; \
	dpkg -i ccache_3.2.4-1_amd64.deb; \
	dpkg -i libapparmor1_2.10-0ubuntu8_amd64.deb; \
	dpkg -i libapparmor-dev_2.10-0ubuntu8_amd64.deb; \
	dpkg -i libgpg-error0_1.20-1_amd64.deb; \
	dpkg -i libgcrypt20_1.6.4-3_amd64.deb; \
	dpkg -i libsystemd0_228-2ubuntu1_amd64.deb; \ 
	dpkg -i libdbus-1-3_1.10.4-1ubuntu2_amd64.deb; \
        dpkg -i libcap-ng0_0.7.7-1_amd64.deb; \
	dpkg -i libfreetype6_2.5.2-4ubuntu2_amd64.deb; \
        dpkg -i ttf-bitstream-vera_1.10-8_all.deb;\
        dpkg -i gsfonts_8.11+urwcyr1.0.7~pre44-4.2ubuntu1_all.deb; \
        dpkg -i libfontenc1_1.1.3-1_amd64.deb \
                libxfont1_1.5.1-1_amd64.deb \
                x11-common_7.7+12ubuntu1_all.deb \
                xfonts-encodings_1.0.4-2_all.deb; \
        dpkg -i xfonts-utils_7.7+3_amd64.deb; \
        dpkg -i gsfonts-x11_0.23_all.deb; \
        dpkg -i fonts-dejavu-core_2.35-1_all.deb; \
        #apt-get -y install ttf-dejavu fonts-dejavu; \

        dpkg -i fontconfig-config_2.11.1-0ubuntu6_all.deb; \
        dpkg -i libfontconfig1_2.11.1-0ubuntu6_amd64.deb; \


        dpkg -i fontconfig_2.11.1-0ubuntu6_amd64.deb; \
        dpkg -i init-system-helpers_1.18_all.deb; \
        dpkg -i ureadahead_0.100.0-19_amd64.deb; \
        dpkg -i --force-confnew dpkg_1.18.3ubuntu1_amd64.deb; \


        dpkg -i --force-all perl-modules_5.20.2-6_all.deb \
            perl-base_5.20.2-6_amd64.deb \
            cli-common_0.9+nmu1_all.deb \
            perl_5.20.2-6_amd64.deb; \

	
        dpkg -i perl-modules_5.20.2-6_all.deb \
            perl-base_5.20.2-6_amd64.deb \
            cli-common_0.9+nmu1_all.deb \
            perl_5.20.2-6_amd64.deb; \
	
	dpkg -i xkb-data_2.10.1-1ubuntu1_all.deb \
		kbd_1.15.5-1ubuntu4_amd64.deb \
		liblocale-gettext-perl_1.07-1_amd64.deb; \

	dpkg -i --force-all keyboard-configuration_1.108ubuntu9_all.deb \
		console-setup_1.108ubuntu9_all.deb \
		console-setup-linux_1.108ubuntu9_all.deb; \

	dpkg -i initramfs-tools-bin_0.120ubuntu6_amd64.deb; \

	dpkg -i libcgmanager0_0.39-2ubuntu2_amd64.deb \
		initramfs-tools_0.120ubuntu6_all.deb; \
	
	dpkg -i --force-all upstart_1.13.2-0ubuntu17_amd64.deb \
		init-system-helpers_1.24ubuntu2_all.deb; \

	dpkg -i upstart_1.13.2-0ubuntu17_amd64.deb \
		init-system-helpers_1.24ubuntu2_all.deb; \

        dpkg -i --auto-deconfigure lsb-base_9.20150917ubuntu1_all.deb || true; \

	dpkg -i keyboard-configuration_1.108ubuntu9_all.deb \
		console-setup_1.108ubuntu9_all.deb \
		console-setup-linux_1.108ubuntu9_all.deb; \

	### Your console font configuration will be updated the next time your system
	### boots. If you want to update it now, run 'setupcon' from a virtual console.
	### update-initramfs: deferring update (trigger activated)
	
	#setupcon; \

	### We are not on the console, the console is left unconfigured.
	dpkg -i dbus_1.10.4-1ubuntu2_amd64.deb; \
	bash -c "if [ -e /var/run/dbus/system_bus_socket ]; then rm /var/run/dbus/system_bus_socket; fi"; \
        bash /docker_scripts/120_dbus.sh; \
        service dbus status; \
        /usr/bin/timedatectl set-timezone  Asia/Taipei; \
        #service dbus stop; \
	cat /dev/null > /var/run/utmp; \

        dpkg --configure -a; \
	bash -c "if [ ! -e /usr/lib/apt/methods/https ]; then ln -snf /root/Downloads/https /usr/lib/apt/methods/https; fi"; \
	bash -c "if [ -e /usr/lib/x86_64-linux-gnu/libgmp.so.10.1.3 ]; then ln -snf /usr/lib/x86_64-linux-gnu/libgmp.so.10.1.3 /usr/lib/x86_64-linux-gnu/libgmp.so.10; fi"

RUN  cd /addfiles/mono_new; \
        dpkg -i --force-all libxml2_2.9.2+zdfsg1-4ubuntu1_amd64.deb \
		libicu55_55.1-6ubuntu1_amd64.deb; \

        dpkg -i libglib2.0-0_2.47.1-1_amd64.deb; \

	dpkg -i libgstreamer0.10-0_0.10.36-1.5ubuntu1_amd64.deb; \
        dpkg -i libdrm-amdgpu1_2.4.65-3_amd64.deb \
            libllvm3.6v5_3.6.2-3build1_amd64.deb \
            libstdc++6_5.2.1-23ubuntu1_amd64.deb \
            gcc-5-base_5.2.1-23ubuntu1_amd64.deb; \

        dpkg -i libxml2_2.9.2+zdfsg1-4ubuntu1_amd64.deb \
		libicu55_55.1-6ubuntu1_amd64.deb; \

        dpkg -i libffi6_3.2.1-3_amd64.deb; \
        dpkg -i libwayland-client0_1.9.0-1_amd64.deb; \
        dpkg -i libdrm2_2.4.65-3_amd64.deb; \
        dpkg -i libdrm-nouveau2_2.4.65-3_amd64.deb; \
        dpkg -i libelf1_0.163-5.1_amd64.deb; \
	dpkg -i libpciaccess0_0.13.4-1_amd64.deb; \
        dpkg -i libdrm-intel1_2.4.65-3_amd64.deb; \
	dpkg -i libxau6_1.0.8-1_amd64.deb \
		libxdmcp6_1.1.2-1_amd64.deb; \
	dpkg -i libxcb1_1.11.1-1ubuntu1_amd64.deb \
		libdrm-radeon1_2.4.65-3_amd64.deb; \

        dpkg -i --force-all libgbm1_11.0.5-1ubuntu2_amd64.deb \
            libwayland-server0_1.9.0-1_amd64.deb \
            libxcb-xfixes0_1.11.1-1ubuntu1_amd64.deb \
            libgl1-mesa-dri_11.0.5-1ubuntu2_amd64.deb; \

	dpkg -i libgbm1_11.0.5-1ubuntu2_amd64.deb \
            libwayland-server0_1.9.0-1_amd64.deb \
            libxcb-xfixes0_1.11.1-1ubuntu1_amd64.deb \
            libgl1-mesa-dri_11.0.5-1ubuntu2_amd64.deb; \

        dpkg -i libgeoclue0_0.12.99-4ubuntu1_amd64.deb \
            liborc-0.4-0_0.4.24-1_amd64.deb; \

	dpkg -i libpixman-1-0_0.33.4-1_amd64.deb; \
	dpkg -i --force-all libharfbuzz0b_1.0.1-1build2_amd64.deb \
		 libgraphite2-3_1.2.4-3ubuntu1_amd64.deb; \

	dpkg -i libharfbuzz0b_1.0.1-1build2_amd64.deb \
		 libgraphite2-3_1.2.4-3ubuntu1_amd64.deb; \

	dpkg -i libx11-data_1.6.3-1ubuntu2_all.deb; \

	dpkg -i libx11-6_1.6.3-1ubuntu2_amd64.deb \
		libxcb-render0_1.11.1-1ubuntu1_amd64.deb \
		libxcb-shm0_1.11.1-1ubuntu1_amd64.deb; \

	dpkg -i libxext6_1.3.3-1_amd64.deb \
		libxrender1_0.9.9-0ubuntu1_amd64.deb; \

	dpkg -i libx11-xcb1_1.6.3-1ubuntu2_amd64.deb \
		libxcb-dri2-0_1.11.1-1ubuntu1_amd64.deb; \

        dpkg -i --force-all libjavascriptcoregtk-1.0-0_2.4.9-2ubuntu2_amd64.deb \
            libcairo2_1.14.4-1_amd64.deb \
            libegl1-mesa_11.0.5-1ubuntu2_amd64.deb \
            libgeoclue0_0.12.99-4ubuntu1_amd64.deb \
            libgstreamer-plugins-base0.10-0_0.10.36-2_amd64.deb \
            libgstreamer1.0-0_1.6.1-1_amd64.deb \
            libharfbuzz-icu0_1.0.1-1build2_amd64.deb; \

        dpkg -i libjavascriptcoregtk-1.0-0_2.4.9-2ubuntu2_amd64.deb \
            libcairo2_1.14.4-1_amd64.deb \
            libegl1-mesa_11.0.5-1ubuntu2_amd64.deb \
            libgeoclue0_0.12.99-4ubuntu1_amd64.deb \
            libgstreamer-plugins-base0.10-0_0.10.36-2_amd64.deb \
            libgstreamer1.0-0_1.6.1-1_amd64.deb \
            libharfbuzz-icu0_1.0.1-1build2_amd64.deb; \



        dpkg -i libgstreamer-plugins-base1.0-0_1.6.1-1ubuntu1_amd64.deb \
            libwebp5_0.4.4-1_amd64.deb; \
        dpkg -i libsoup2.4-1_2.52.2-1_amd64.deb \
            libwebkitgtk-1.0-common_2.4.9-2ubuntu2_all.deb; \

        dpkg -r cmake; \
        dpkg -r libarchive13; \
        dpkg -r libnettle4; \


	dpkg -i liblzo2-2_2.08-1.2_amd64.deb; \

	dpkg -i libnettle6_3.1.1-4_amd64.deb \
		libhogweed4_3.1.1-4_amd64.deb \
		libgmp10_6.1.0+dfsg-2_amd64.deb; \
	dpkg -i librtmp1_2.4+20150115.gita107cef-1build1_amd64.deb \
		libssl1.0.0_1.0.2d-0ubuntu2_amd64.deb; \

	dpkg -i libgnutls-deb0-28_3.3.18-1ubuntu1_amd64.deb; \

	dpkg -i libnspr4_4.10.10-1ubuntu1_amd64.deb \
		libnspr4-0d_4.10.10-1ubuntu1_amd64.deb \
		libnss3-nssdb_3.19.2.1-0ubuntu1_all.deb; \

	dpkg -i --force-all libcurl3_7.45.0-1ubuntu1_amd64.deb \
		libcurl3-gnutls_7.45.0-1ubuntu1_amd64.deb \
		libcurl4-gnutls-dev_7.45.0-1ubuntu1_amd64.deb \
		libnss3_3.19.2.1-0ubuntu1_amd64.deb \
		libcurl3-nss_7.45.0-1ubuntu1_amd64.deb; \
		#libcurl4-nss-dev_7.45.0-1ubuntu1_amd64.deb; \

	dpkg -i libcurl3_7.45.0-1ubuntu1_amd64.deb \
		libcurl3-gnutls_7.45.0-1ubuntu1_amd64.deb \
		libcurl4-gnutls-dev_7.45.0-1ubuntu1_amd64.deb \
		libnss3_3.19.2.1-0ubuntu1_amd64.deb \
		libcurl3-nss_7.45.0-1ubuntu1_amd64.deb; \
		#libcurl4-nss-dev_7.45.0-1ubuntu1_amd64.deb; \



        dpkg -i libarchive13_3.1.2-11build1_amd64.deb; \
        #dpkg -i libnettle6_3.1.1-4_amd64.deb \
        dpkg -i cmake-data_3.3.2is3.2.2-0ubuntu2_all.deb \
            libjsoncpp0v5_0.10.5-1_amd64.deb; \



        dpkg -i cmake_3.3.2is3.2.2-0ubuntu2_amd64.deb; \
        #dpkg -i libgmp10_6.1.0+dfsg-2_amd64.deb \
            #libhogweed4_3.1.1-4_amd64.deb \
        dpkg -i libp11-kit0_0.23.1-3_amd64.deb \
            libtasn1-6_4.7-2_amd64.deb; \


        dpkg -i libdconf1_0.24.0-2_amd64.deb; \
        dpkg -i dconf-gsettings-backend_0.24.0-2_amd64.deb; \

        #dpkg -i libgnutls-deb0-28_3.3.18-1ubuntu1_amd64.deb \
        dpkg -i libproxy1v5_0.4.11-4ubuntu3~gcc5.3_amd64.deb \
            gsettings-desktop-schemas_3.18.1-1ubuntu1_all.deb; \


        dpkg -i libsoup2.4-1_2.52.2-1_amd64.deb; \

        dpkg -i glib-networking_2.46.1-1_amd64.deb \
            glib-networking-common_2.46.1-1_all.deb \
            glib-networking-services_2.46.1-1_amd64.deb; \

        dpkg -i libwebkitgtk-1.0-0_2.4.9-2ubuntu2_amd64.deb; \
        dpkg -i monodevelop_5.5.0.227-1_all.deb

	dpkg -i libtext-charwidth-perl_0.04-7build4_amd64.deb \
		libtext-iconv-perl_1.7-5build3_amd64.deb \
		libtext-soundex-perl_3.4-1build2_amd64.deb; \
