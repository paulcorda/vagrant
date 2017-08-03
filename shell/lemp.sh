#!/usr/bin/env bash

# Variables
LOG_DIR='log'
LOG=${LOG_DIR}'/lemp.log'

if [ ! -e ${LOG_DIR} ] ; then
    mkdir ${LOG_DIR}
fi

if [ ! -e ${LOG} ] ; then
    touch ${LOG}
else
    : > ${LOG}
fi

echo -e "\n--- Updating packages list ---\n"
add-apt-repository ppa:ondrej/php >> ${LOG} 2>&1
apt-get -qq update

echo -e "\n--- Installing base packages ---\n"
apt-get -y -f install vim curl build-essential python-software-properties git >> ${LOG} 2>&1

echo -e "\n--- Installing MySQL-specific packages (blank root password) ---\n"
echo "mysql-server mysql-server/root_password password " | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password " | debconf-set-selections
apt-get -y -f install mysql-server mysql-client >> ${LOG} 2>&1

echo -e "\n--- Installing nginx-specific packages ---\n"
apt-get -y -f install nginx >> ${LOG} 2>&1

echo -e "\n--- Installing PHP-specific packages ---\n"
apt-get -y -f install php7.1 php7.1-fpm php7.1-cli >> ${LOG} 2>&1

echo -e "\n--- Installing Composer for PHP package management ---\n"
curl -sS https://getcomposer.org/installer | php >> ${LOG} 2>&1
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

echo -e "\n--- Setting up Virtual Host (TODO) ---\n"

echo -e "\n--- Cleaning up ---\n"
apt-get clean >> ${LOG} 2>&1

echo -e "\n--- Restarting nginx ---\n"
service nginx restart >> ${LOG} 2>&1
