#!/bin/bash

# Get provisionning directory
dir=/vagrant/vagrant
scripts=$dir/scripts

# Load configuration
. $dir/config.sh

# Load libraries
. $dir/scripts/lib.sh

# Server configuration
if [ "$1" == "1" ]; then
    $scripts/server/user.sh
    $scripts/server/repos.sh
    $scripts/server/update.sh
    $scripts/server/ssh.sh "${CONFIG['server:ssh_key']}" "${CONFIG['server:known_hosts']}"
    $scripts/server/ntp.sh "${CONFIG['server:timezone']}"
    $scripts/server/fixes.sh
fi

if [ "$1" == "2" ]; then
    # Get script arguments
    domain="$2"
    domains="$3"

    # Web server configuration
    if [ -f $scripts/web/${CONFIG['web:mode']}.sh ]; then
        $scripts/web/${CONFIG['web:mode']}.sh "$domain" "$domains" "${CONFIG['web:webroots']}"
    fi

    # PHP configuration
    if [ ${CONFIG['php:enabled']} ]; then
        if [ -f $scripts/php/php-${CONFIG['php:version']}.sh ]; then
            $scripts/php/php-${CONFIG['php:version']}.sh "${CONFIG['server:timezone']}" "${CONFIG['php:modules']}" "$scripts/php"
        fi
        if [ ${CONFIG['php:composer']} ]; then
            $scripts/php/composer.sh
        fi
    fi

    # Database configuration
    if [ -f $scripts/database/${CONFIG['database:mode']}.sh ]; then
        $scripts/database/${CONFIG['database:mode']}.sh "${CONFIG['server:timezone']}" "${CONFIG['database:fixtures']}" "$scripts/database"
    fi

    # Tools configuration
    if [ ${CONFIG['phpmyadmin:enabled']} ]; then
        $scripts/tools/phpmyadmin.sh
    fi
    if [ ${CONFIG['nodejs:enabled']} ]; then
        $scripts/tools/nodejs.sh "${CONFIG['nodejs:libraries']}"
    fi
    if [ ${CONFIG['ruby:enabled']} ]; then
        $scripts/tools/ruby.sh "${CONFIG['ruby:gems']}"
    fi

    # Symfony configuration
    if [ ${CONFIG['symfony:installer']} ]; then
        $scripts/symfony/installer.sh
    fi
    if [ ${CONFIG['symfony:completion']} ]; then
        $scripts/symfony/completion.sh
    fi
    if [ ${CONFIG['symfony:twig']} ]; then
        $scripts/symfony/twig.sh
    fi

    # Search engine configuration
    if [ ${CONFIG['search:enabled']} ] && [ -f $scripts/search/${CONFIG['search:mode']}.sh ]; then
        $scripts/search/${CONFIG['search:mode']}.sh
    fi

    # Finalize
    $scripts/finalize.sh
fi
