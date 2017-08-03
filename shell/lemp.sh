#!/usr/bin/env bash

# Variables
LOG=.vagrant/provision.log

echo -e "\n--- Provisioning vagrant box ---\n"
echo -e "\n--- Check .vagrant/provision.log for full output ---\n"

echo -e "\n--- Updating packages list ---\n"
apt-get -qq update

echo -e "\n--- Install base packages ---\n"
apt-get -y -f install vim curl build-essential python-software-properties git >> ${LOG} 2>&1

echo -e "\n--- Install MySQL specific packages and settings (blank root password) ---\n"
echo "mysql-server mysql-server/root_password password " | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password " | debconf-set-selections

echo -e "\n--- Installing MySQL-specific packages ---\n"
apt-get -y -f install mysql-server mysql-client >> ${LOG} 2>&1

echo -e "\n--- Installing nginx-specific packages ---\n"
apt-get -y -f install nginx >> ${LOG} 2>&1

echo -e "\n--- Installing PHP-specific packages ---\n"
apt-get -y install php7.1-fpm >> ${LOG} 2>&1

echo -e "\n--- Installing Composer for PHP package management ---\n"
curl -sS https://getcomposer.org/installer | php >> ${LOG} 2>&1
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

echo -e "\n--- Setting up Virtual Host (TODO) ---\n"

echo -e "\n--- Cleaning up ---\n"
apt-get clean >> ${LOG} 2>&1

echo -e "\n--- Restarting nginx ---\n"
service nginx restart >> ${LOG} 2>&1
