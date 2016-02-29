#!/bin/bash

cd /root/Downloads/clusterLab/pcs;
gem install bundler rdoc --no-rdoc --no-ri;
cp pcs / -Rf;
cd /pcs;
gem install ruby_gem --no-rdoc --no-ri;
gem install rubygems-update --no-rdoc --no-ri;
update_rubygems;
gem update --system;
chown hacluster:haclient /pcs -R;
cd /pcs/pcsd;
echo | gem install bundler rdoc --no-rdoc --no-ri;
setuser hacluster  bundle install --path vendor/bundle;
cd ..;
make install_pcsd;
make install;
sship=$(grep -P ^ListenAddress /etc/ssh/sshd_config|awk '{print $2}');
service ssh restart;
service ssh status;
sed -i.bak -r s/\:Host[[:space:]]+=\>[[:space:]]+\'\:\:\',/\:Host\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ =\>\ \'$sship\',/g /usr/share/pcsd/ssl.rb;
sed -i.bak -r s/\\/usr\\/lib\\/pcsd\\//\\/usr\\/share\\/pcsd\\//g /usr/share/pcsd/settings.rb;
#/usr/bin/ruby -C/var/lib/pcsd -I/usr/share/pcsd -- /usr/share/pcsd/ssl.rb;
chown hacluster:haclient /usr/lib/ruby/gems/1.9.1 -R;
echo | gem install bundler rdoc rack sinatra sinatra-reloader open4 orderedhash rpam --no-rdoc --no-ri;
service pcsd start;

cd /root/Downloads/clusterLab/corosync/corosync
make install

