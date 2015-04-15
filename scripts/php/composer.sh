#!/bin/bash

if [ ! -f /usr/local/bin/composer ] ; then
    echo 'Installing composer'
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    chown vagrant:vagrant /usr/local/bin/composer
    
    # Add composer update cron
    echo '0 * * * * /usr/local/bin/composer self-update' >> /etc/crontab
fi
