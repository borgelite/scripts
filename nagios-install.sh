#!/bin/bash
#Anleitung
#https://www.linode.com/docs/uptime/monitoring/install-nagios-4-on-ubuntu-debian-8

#git clone https://gist.github.com/kevinbin/8514120
#cd 8514120
#chmod +x *
#./nagios-install

#!/bin/sh
# Any Failing Command Will Cause The Script To Stop
#set -e
# Treat Unset Variables As Errors
#set -u
#NAGIOS_VERSION=3.5.0
#NAGIOS_VERSION=4.2.3
#PLUGIN_VERSION=2.1.4
#https://nagios-plugins.org/download/nagios-plugins-2.1.4.tar.gz
#echo "***** Starting Nagios Quick-Install: " `date`
#echo "***** Installing pre-requisites"
#yum -y install httpd gcc glibc glibc-common gd gd-devel php
#aptitude -y install httpd gcc glibc glibc-common gd gd-devel php apache2
#sudo apt-get install build-essential unzip openssl libssl-dev libgd2-xpm-dev xinetd apache2-utils

#echo "***** Setting up the environment"
#useradd -m nagios
#echo "nagios" | passwd --stdin nagios
#groupadd nagcmd
#usermod -a -G nagcmd nagios
#usermod -a -G nagcmd apache

#echo "***** Getting the Nagios Source $NAGIOS_VERSION and Plug-Ins $PLUGIN_VERSION"
#cd /usr/local/src
#wget -c http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-$NAGIOS_VERSION.tar.gz
#wget -c https://nagios-plugins.org/download/nagios-plugins-$PLUGIN_VERSION.tar.gz
#tar xzf nagios-$NAGIOS_VERSION.tar.gz
#tar xzf nagios-plugins-$PLUGIN_VERSION.tar.gz

echo "***** Installing Nagios"
#cd /usr/local/src/nagios
git clone https://github.com/NagiosEnterprises/nagioscore
cd nagioscore
./configure --with-command-group=nagcmd
make all
make install
make install-init
make install-config
make install-commandmode
make install-webconf
sudo ln -sf /usr/local/nagios/etc/* /etc/nagios/

echo "***** Installing Nagios-Plugins *****"
wget wget https://nagios-plugins.org/download/nagios-plugins-2.1.4.tar.gz
tar xfz nagios-plugins-2.1.4.tar.gz
cd nagios-plugins-2.1.4
./configure
make all -j4
make install

echo "***** Setting up htpasswd auth"
htpasswd -nb nagiosadmin nagios > /usr/local/nagios/etc/htpasswd.users
echo "Set Standard User:PW nagiosadmin:nagios"
echo "To chance"
echo "htpasswd -nb nagiosadmin nagios > /usr/local/nagios/etc/htpasswd.users"

#service httpd restart
sudo a2enmod rewrite && sudo a2enmod cgi
adduser www-data www-data
service apache2 restart
service nagios restart

#echo "***** Setting up Nagios Plug-Ins"
#cd /usr/local/src/nagios-plugins-$PLUGIN_VERSION
#./configure --with-nagios-user=nagios --with-nagios-group=nagios
#make
#make install

#echo "***** Fixing SELinux"
#if [[ `getenforce` == Enforcing ]]; then
#  chcon -R -t httpd_sys_content_t /usr/local/nagios/sbin/
#  chcon -R -t httpd_sys_content_t /usr/local/nagios/share/
#fi


#echo "***** Starting Nagios"
#chkconfig --add nagios
#chkconfig nagios on
#service nagios start

echo "***** Done: " `date`
