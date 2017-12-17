#!/usr/bin/env bash

echo -e "\n--- Updating packages list ---\n"
add-apt-repository ppa:ondrej/php
apt-get -qq update

echo -e "\n--- Installing base packages ---\n"
apt-get -y -f -q install vim curl build-essential python-software-properties git

echo -e "\n--- Installing MySQL-specific packages (blank root password) ---\n"
echo "mysql-server mysql-server/root_password password " | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password " | debconf-set-selections
apt-get -y -f install mysql-server mysql-client

echo -e "\n--- Installing nginx-specific packages ---\n"
apt-get -y -f install nginx

echo -e "\n--- Installing PHP-specific packages ---\n"
apt-get -y -f install php7.1 php7.1-fpm php7.1-cli

echo -e "\n--- Installing Composer for PHP package management ---\n"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

echo -e "\n--- Setting up Virtual Host (TODO) ---\n"

echo -e "\n--- Cleaning up ---\n"
apt-get -q clean

service nginx restart
