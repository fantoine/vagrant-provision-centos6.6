#!/bin/bash

# Get provisionning directory
dir=/vagrant/vagrant
scripts=$dir/scripts

# Load configuration
. "$1"

# Server configuration
if [ "$2" == "server" ]; then
    $scripts/server/user.sh
    $scripts/server/repos.sh
    $scripts/server/update.sh
    $scripts/server/ssh.sh "${CONFIG['server:ssh_key']}" "${CONFIG['server:known_hosts']}"
    $scripts/server/ntp.sh "${CONFIG['server:timezone']}"
    $scripts/server/fixes.sh
fi

# Installation
if [ "$2" == "install" ]; then
    # Get script arguments
    domain="$3"
    domains="$4"

    # Web server configuration
    if [ -f "$scripts/web/${CONFIG['web:mode']}.sh" ]; then
        $scripts/web/${CONFIG['web:mode']}.sh "$domain" "$domains" "${CONFIG['web:webroots']}" "${CONFIG['web:ssl']}"
    fi

    # PHP configuration
    if [ ${CONFIG['php:enabled']} == true ]; then
        if [ -f "$scripts/php/php-${CONFIG['php:version']}.sh" ]; then
            $scripts/php/php-${CONFIG['php:version']}.sh "${CONFIG['server:timezone']}" "${CONFIG['php:modules']}" "$scripts/php"
        fi
        if [ "${CONFIG['php:composer:enabled']}" ]; then
            $scripts/php/composer.sh "${CONFIG['php:composer:github_token']}"
        fi
        if [ "${CONFIG['php:phpunit']}" ]; then
            $scripts/php/phpunit.sh
        fi
    fi

    # Database configuration
    if [ "${CONFIG['database:sql:enabled']}" == true ] && [ -f "$scripts/database/sql/${CONFIG['database:sql:mode']}.sh" ]; then
        $scripts/database/sql/${CONFIG['database:sql:mode']}.sh "${CONFIG['server:timezone']}" "${CONFIG['database:sql:fixtures']}" "$scripts/database/sql"
    fi
    if [ "${CONFIG['database:redis:enabled']}" == true ]; then
        $scripts/database/redis.sh "${CONFIG['database:redis:version']}"
    fi

    # Tools configuration
    if [ "${CONFIG['phpmyadmin:enabled']}" == true ]; then
        $scripts/tools/phpmyadmin.sh
    fi
    if [ "${CONFIG['nodejs:enabled']}" == true ]; then
        $scripts/tools/nodejs.sh "${CONFIG['nodejs:libraries']}"
    fi
    if [ "${CONFIG['ruby:enabled']} == true" ]; then
        $scripts/tools/ruby.sh "${CONFIG['ruby:gems']}"
    fi

    # Symfony configuration
    if [ "${CONFIG['symfony:installer']}" == true ]; then
        $scripts/symfony/installer.sh
    fi
    if [ "${CONFIG['symfony:completion']}" == true ]; then
        $scripts/symfony/completion.sh
    fi
    if [ "${CONFIG['symfony:twig']}" == true ]; then
        $scripts/symfony/twig.sh
    fi

    # Search engine configuration
    if [ "${CONFIG['search:enabled']}" == true ] && [ -f "$scripts/search/${CONFIG['search:mode']}.sh" ]; then
        $scripts/search/${CONFIG['search:mode']}.sh
    fi

    # Finalize
    $scripts/finalize.sh
fi
