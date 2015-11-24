#!/bin/bash

from="robotica/xlbase:0.6.4-no-pcmk"
dtag="robotica/pcmk_ubuntu:0.6.1"
debs=""
corosync_config=""
export_file=""
parent="/root/alias/pacemaker_docker_ubuntu"

make_image()
{
	cd $parent
	echo "Making Dockerfile"
	rm -f Dockerfile

	if [ -z "$corosync_config" ]; then
		corosync_config="./defaults/corosync.conf"
	fi

	echo "FROM $from" > Dockerfile

	#rm -rf repos
	mkdir -p $parent/repos
	if [ -n "$repodir" ]; then
		cp $repodir/* $parent/repos/
		echo "ADD ./repos /etc/apt.repos.d/" >> Dockerfile
	fi

	#rm -rf debs 
	mkdir -p $parent/debs
	if [ -n "$debdir" ]; then
		cp $debdir/* ./debs/
	fi
	#echo "ADD ./debs /root/debs" >> Dockerfile
	echo "RUN mkdir -p /addfiles/packages_pcmk; \\" >> Dockerfile
	
	#for f in $(ls $parent/debs/); do
	#	echo "ADD $parent/debs/$f /root/debs/$f"
	#	echo "ADD ./debs/$f /root/debs/$f" >> Dockerfile
	#done
	
	echo "ADD ./debs/ /addfiles/packages_pcmk" >> Dockerfile
	echo "ADD ./helper_scripts /usr/sbin" >> Dockerfile
	echo "ADD ./pcsd.sh /root/pcsd.sh" >> Dockerfile
	echo "ADD $corosync_config /etc/corosync/" >> Dockerfile
	echo "ADD ./functions /lib/lsb/init-functions" >> Dockerfile
	

	echo "RUN bash /addfiles/packages_pcmk/do.sh; \\" >> Dockerfile
	echo "	apt-get -y update; apt-get -y upgrade; \\" >> Dockerfile
	echo "	mkdir -p /root/pcsds; mkdir -p /etc/rc.d/init.d/; \\" >> Dockerfile
	echo "	ln -s /lib/lsb/init-functions /etc/rc.d/init.d/functions" >> Dockerfile

	echo "ADD ./pcsd /root/pcsds" >> Dockerfile

	###@ not mod system now @###
	#echo "RUN cp /root/pcsds/* /usr/share/pcsd -f" >> Dockerfile


	# generate image
	echo "Making image"
	dbuild $dtag .
	if [ $? -ne 0 ]; then
		echo "ERROR: failed to generate docker image"
		exit 1
	fi
	#image=$(docker $doc_opts images -q | head -n 1)

	#if [ -z "$export_file" ]; then
	#	export_file="pcmk_container_${image}.tar"

	#fi
	#docker save $image > ${export_file}

	#echo "Docker container $image is exported to tar file ${export_file}"

	# cleanup
	#rm -rf debs repos
}

function helptext() {
	echo "pcmk_create_image.sh - A tool for creating a pacemaker docker image."
	echo ""
	echo "Usage: pcmk_create_image.sh [options]"
	echo ""
	echo "Options:"
	echo "-f, --from               Specify the FROM image to base the docker containers off of. Default is \"$from\""
	echo "-o, --repo-copy          Copy the repos in this host directory into the image's /etc/apt.repos.d/ directory"
	echo "-R, --deb-copy           Copy debs in this directory to image for install".
	#echo "-e, --export-file        Export pacemaker container image to this file path.".
	echo ""
	exit $1
}

while true ; do
	case "$1" in
	--help|-h|-\?) helptext 0;;
	-f|--from) from="$2"; shift; shift;;
	-o|--repo-copy) repodir=$2; shift; shift;;
	-R|--deb-copy) debdir=$2; shift; shift;;
	-e|--export-file) export_file=$2; shift; shift;;
	"") break;;
	*) 
		echo "unknown option $1"
		helptext 1;;
	esac
done

make_image

