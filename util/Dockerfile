FROM ubuntu:14.04
MAINTAINER ingted

ENV DEBIAN_FRONTEND noninteractive

ADD ./image/ /bd_build/
ADD ./addfiles/ /addfiles/

RUN ln -snf /bin/bash /bin/sh; \
	#ls -l /bin/sh; \
	#ls -l /bd_build; \
	ls -l /addfiles; \
	cp -rf /bd_build/util /; \
	cp /addfiles/sources.list               /etc/apt/; \
	/bd_build/prepare.sh && \
	/bd_build/system_services.sh && \
	/bd_build/utilities.sh && \
	/bd_build/cleanup.sh; \
	apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D; \
        echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list; \
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A6A19B38D3D831EF; \


	apt-get -y update; \
	apt-get -y install make dbus git mono-devel mono-complete referenceassemblies-pcl sshpass autoconf automake pkg-config
RUN mkdir -p /fs; \
        cd /fs; \
        rm fsharp -f; \
        git clone https://github.com/fsharp/fsharp.git; \
        cd fsharp; \
        mkdir -p .paket; \
	cp /addfiles/paket.bootstrapper.exe /fs/fsharp/.paket/paket.bootstrapper.exe; \
        cp /addfiles/paket.dependencies /fs/fsharp/paket.dependencies; \

        cd /fs/fsharp/.paket/; \
        mono paket.bootstrapper.exe; \
        mono paket.exe update; \

        cd /fs/fsharp/; \
        ./autogen.sh --prefix=/usr; \
        make; \
        make install; \
        cd /fs/fsharp/; \
        chmod +x src/fsharp/fsi/obj/release/*; \
        cp src/fsharp/fsi/obj/release/* /usr/bin/; \
	cp /usr/bin/fsi.exe /usr/bin/fsi; \
	chmod +x src/fsharp/FSharp.Compiler.Interactive.Settings/obj/release/*; \
        cp src/fsharp/FSharp.Compiler.Interactive.Settings/obj/release/* /usr/bin/; \
        chmod +x src/fsharp/Fsc/obj/release/*; \
        cp src/fsharp/Fsc/obj/release/* /usr/bin/; \


        mkdir -p /pash; \
        cd /pash; \
        git clone https://github.com/ingted/Pash.git; \
        cd Pash; \
        cp /addfiles/FileSystemProvider.cs ./Source/System.Management/Microsoft.PowerShell/Commands/; \
        xbuild



RUN cp /addfiles/dbus*  /usr/bin/; \
	mkdir -p /util; \
	cd /util; \
	git init; \
  	git remote add -f origin https://github.com/ingted/xlbase.git; \
  	git config core.sparseCheckout true; \
  	echo "mgmt/*" >> .git/info/sparse-checkout; \
  	echo "alias/*" >> .git/info/sparse-checkout; \
  	echo "UTILVER" >> .git/info/sparse-checkout; \
	git checkout --track -b backToOrigin origin/backToOrigin; \
        #cp /addfiles/pash /usr/sbin; \
        #cp /addfiles/fsi /usr/sbin; \
        cp /addfiles/fsc /usr/sbin; \
	cp /pash/Pash/Source/PashConsole/bin/Debug/Pash.exe /pash/Pash/Source/PashConsole/bin/Debug/pash; \
	cp /pash/Pash/Source/PashConsole/bin/Debug/* /usr/bin; \
	sudo cp /addfiles/rc.local /etc; \
        cp /addfiles/libsystemd.so.0            /lib/x86_64-linux-gnu/libsystemd.so.0; \
        cp /addfiles/libgcrypt.so.20            /lib/x86_64-linux-gnu/libgcrypt.so.20; \
        cp /addfiles/timedatectl                /usr/bin/; \
        cp /addfiles/gnu/libcurl-gnutls.so.4    /usr/lib/x86_64-linux-gnu/; \
        cp /addfiles/gnu/libgmp.so.10           /usr/lib/x86_64-linux-gnu/; \
        cp /addfiles/gnu/librtmp.so.1           /usr/lib/x86_64-linux-gnu/; \
        cp /addfiles/gnu/libssh2.so.1           /usr/lib/x86_64-linux-gnu/; \
        cp /addfiles/gnu/libnettle.so.4         /usr/lib/x86_64-linux-gnu/; \
        cp /addfiles/gnu/libgnutls-deb0.so.28   /usr/lib/x86_64-linux-gnu/; \
        cp /addfiles/gnu/libhogweed.so.2        /usr/lib/x86_64-linux-gnu/; \
        cp /addfiles/gnu/libcap-ng.so.0         /usr/lib/x86_64-linux-gnu/; \
	chmod 755 /etc/container_environment; \
        echo "\[\e]0;\u@\$(hostname):\ \w\a\]${debian_chroot:+(\$debian_chroot)}\[\033[01;36m\]\u@\$(hostname)\[\033[00m\]:\[\033[01;32m\]\w\[\033[00m\]\\\$ " > /etc/container_environment/PS1; \
	echo "export HOME=/root/" >> /root/.bashrc; \
	cat /addfiles/bashrc_4_ps1 >> /root/.bashrc


#ENTRYPOINT ["/bin/bash"]
CMD ["/sbin/my_init"]
