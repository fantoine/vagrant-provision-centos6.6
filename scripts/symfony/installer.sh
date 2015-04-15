#!/bin/bash

if [ ! -f /usr/local/bin/symfony ]; then
    echo 'Installing Symfony installer'
    wget -O /usr/local/bin/symfony http://symfony.com/installer
    chmod a+x /usr/local/bin/symfony
fi
