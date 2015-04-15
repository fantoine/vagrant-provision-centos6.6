#!/bin/bash

if [ ! -f /etc/php.d/twig.ini ]; then
    echo 'Installing Twig PHP extension'

    mkdir -p /tmp/twig

    # Download twig
    git clone https://github.com/twigphp/Twig.git /tmp/twig

    # Compile & Install
    pushd /tmp/twig/ext/twig/
    phpize && ./configure && make && make install
    popd

    # Clean temporary files
    rm -r /tmp/twig

    # Enable module
    echo '; Enable twig extension module' > /etc/php.d/twig.ini
    echo 'extension=twig.so' >> /etc/php.d/twig.ini

    # Restart Apache
    service httpd restart
fi
