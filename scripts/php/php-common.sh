#!/bin/bash

phpName="$1"
timezone="$2"
read -a modules <<< "$3"

if [ ! -f /etc/php.ini ]; then
    echo "Installing PHP and modules"
    yum install -y $phpName ${modules[@]/#/$phpName-} --enablerepo=webtatic

    # Use the dev php.ini file
    cp -f /usr/share/doc/$phpName-*/php.ini-development /etc/php.ini

    # Update configuration
    sed -i \
        -e "s/;date\.timezone =.*/date.timezone = $timezone/" \
        -e 's/memory_limit =.*/memory_limit = 1G/' \
        -e 's/error_reporting =.*/error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_STRICT/' \
        /etc/php.ini

    # Chown session folder
    chown -R vagrant:vagrant /var/lib/php/session
    
    # Restarting Apache
    service httpd restart
fi