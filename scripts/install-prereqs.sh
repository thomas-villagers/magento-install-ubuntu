#!/bin/bash
echo "Install and configure Magento prerequisites on Ubuntu systems."
echo "Please run as sudo" 
echo "Install openssh-server"
apt-get install openssh-server
echo "Install and configure Apache" 
apt-get install apache2
a2enmod rewrite 

echo "Modify /etc/apache2/sites-enabled/000-default.conf"
cp /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf.old
echo '<Directory "/var/www/html">' >> /etc/apache2/sites-enabled/000-default.conf
echo '  Options Indexes FollowSymlinks MultiViews' >> /etc/apache2/sites-enabled/000-default.conf
echo '  AllowOverride All' >> /etc/apache2/sites-enabled/000-default.conf
echo '</Directory>' >> /etc/apache2/sites-enabled/000-default.conf

echo "Install and configure php 5.6 and php 7.0" 
add-apt-repository ppa:ondrej/php
apt-get update
apt-get install php7.0 php5.6 php5.6-mysql php-gettext php5.6-mbstring php-xdebug libapache2-mod-php5.6 libapache2-mod-php7.0 php5.6-curl php5.6-gd php5.6-mcrypt php5.6-xml php5.6-soap php5.6-xmlrpc

echo "Activate php 5.6"
a2dismod php7.0
a2enmod php5.6
ln -sfn /usr/bin/php5.6 /etc/alternatives/php

echo "Increase PHP memory limit (512M)"
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/5.6/apache2/php.ini 

echo "Install mysql"
apt-get install mysql-client mysql-server
apt-get install phpmyadmin 

service apache2 restart
