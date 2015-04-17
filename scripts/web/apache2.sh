#!/bin/bash

domain="$1"
read -a domains <<< "$2"
read -a webroots <<< "$3"

conf='/etc/httpd/conf.d/vagrant.conf'

if [ ! -f /etc/httpd/conf/httpd.conf ] ; then
    echo 'Installing Apache'
    yum install -y httpd >/dev/null 2>&1
    chkconfig httpd on >/dev/null 2>&1

    # Add upstart script
    cp /vagrant/vagrant/data/web/init-httpd.conf /etc/init/
fi

if [ ! -f $conf ] ; then
    for i in ${webroots[@]}
    do
        if [ -d $i ]
        then
            echo 'Mounting webroot on' $i
            webroot=$i
            break
        fi
    done

    # Update default httpd configuration
    sed -i \
        -e 's/User .*/User vagrant/' \
        -e 's/Group .*/Group vagrant/' \
        -e 's/#EnableSendfile .*/EnableSendfile off/' \
        /etc/httpd/conf/httpd.conf

    # Add configuration
    cp /vagrant/vagrant/data/web/httpd.conf $conf

    # Inject variables
    sed -i \
        -e "s@:domain:@$domain@g" \
        -e "s@:webroot:@$webroot@g" \
        $conf
    for sub in ${domains[@]}
    do
        sed -i -e "/ServerName.*/a    ServerAlias $sub.$domain" $conf
    done

    # Restarting httpd service
    service httpd restart >/dev/null 2>&1
fi
