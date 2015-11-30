FROM ubuntu:14.04
MAINTAINER ingted

ENV DEBIAN_FRONTEND noninteractive

ADD . /bd_build
ADD ./addfiles /addfiles

RUN cp -rf /bd_build/util /; \
	/bd_build/prepare.sh && \
	/bd_build/system_services.sh && \
	/bd_build/utilities.sh && \
	/bd_build/cleanup.sh; \
	apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D; \
        echo "deb http://download.mono-project.com/repo/debian wheezy main" | tee /etc/apt/sources.list.d/mono-xamarin.list; \
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A6A19B38D3D831EF; \


	apt-get -y update; \
	apt-get -y install dbus git mono-devel mono-complete referenceassemblies-pcl sshpass autoconf automake pkg-config; \
	mkdir -p /fs; \
        cd /fs; \
        rm fsharp -f; \
        git clone https://github.com/fsharp/fsharp.git; \
        cd fsharp; \
        mkdir -p .paket; \
	cp /addfiles/paket.bootstrapper.exe /fs/fsharp/.paket/paket.bootstrapper.exe; \
        cp /addfiles/paket.dependencies /fs/fsharp/paket.dependencies; \

        cd /root/Downloads/fs/fsharp/.paket/; \
        mono paket.bootstrapper.exe; \
        mono paket.exe update; \

        cd /fs/fsharp/; \
        ./autogen.sh --prefix=/usr; \
        make; \
        make install; \
        chmod +x src/fsharp/fsi/obj/release/*; \
        cp src/fsharp/fsi/obj/release/* /usr/bin/; \
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
	cd /util; \
	git init; \
  	git remote add -f origin https://github.com/ingted/xlbase.git; \
  	git config core.sparseCheckout true; \
  	echo "mgmt/*" >> .git/info/sparse-checkout; \
  	echo "alias/*" >> .git/info/sparse-checkout; \
  	echo "UTILVER" >> .git/info/sparse-checkout; \
	git checkout --track -b backToOrigin origin/backToOrigin; \
        #cp /addfiles/pash /usr/sbin; \
        cp /addfiles/fsi /usr/sbin; \
        cp /addfiles/fsc /usr/sbin; \
	cp /pash/Pash/Source/PashConsole/bin/Debug/Pash.exe /pash/Pash/Source/PashConsole/bin/Debug/pash; \
	cp /pash/Pash/Source/PashConsole/bin/Debug/* /usr/bin; \
	sudo cp /addfiles/rc.local /etc

CMD ["/sbin/my_init"]
