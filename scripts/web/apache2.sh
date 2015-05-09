#!/bin/bash

domain="$1"
read -a domains <<< "$2"
read -a webroots <<< "$3"
ssl="$4"

conf='/etc/httpd/conf.d/vagrant.conf'
sslconf='/etc/httpd/conf.d/vagrant.ssl.conf'
sslpath="/etc/ssl/${domain}"
sslfile="${sslpath}/${domain}"

if [ ! -f /etc/httpd/conf/httpd.conf ] ; then
    echo 'Installing Apache'
    yum install -y httpd mod_ssl >/dev/null 2>&1
    chkconfig httpd on >/dev/null 2>&1

    # Add upstart script
    cp /vagrant/vagrant/data/web/init-httpd.conf /etc/init/

    # Update default httpd configuration
    sed -i \
        -e 's/#NameVirtualHost .*/NameVirtualHost *:80/' \
        -e 's/User .*/User vagrant/' \
        -e 's/Group .*/Group vagrant/' \
        -e 's/#EnableSendfile .*/EnableSendfile off/' \
        /etc/httpd/conf/httpd.conf
fi

function apache2_conf {
    template="$1"
    target="$2"
    webroot="$3"
    domain="$4"

    # Add configuration
    cp $template $target

    # Inject variables
    sed -i \
        -e "s@:domain:@$domain@g" \
        -e "s@:webroot:@$webroot@g" \
        $target
    for sub in ${domains[@]}
    do
        sed -i -e "/ServerName.*/a    ServerAlias $sub.$domain" $target
    done
}

if [ ! -f $conf ] || [[ "$ssl" == "true" && (! -f $sslconf) ]]; then
    for i in ${webroots[@]}
    do
        if [ -d $i ]
        then
            echo 'Mounting webroot on' $i
            webroot=$i
            break
        fi
    done

    # Add default configuration
    echo 'Adding default Virtualhost'
    apache2_conf /vagrant/vagrant/data/web/httpd.conf $conf $webroot $domain

    # Add ssl configuration
    if [ "$ssl" == "true" ]; then
        echo 'Generating SSL certificates'
        mkdir -p "$sslpath"
        openssl req \
            -new -newkey rsa:2048 -days 365 -nodes -x509 \
            -subj "/C=US/ST=Denial/L=Springfield/O=Vagrant/OU=Dev/CN=*.${domain}/emailAddress=contact@${domain}" \
            -keyout "${sslfile}.key" \
            -out "${sslfile}.crt" >/dev/null 2>&1
        chmod 400 "${sslfile}.key" "${sslfile}.pem"

        echo 'Adding SSL Virtualhost'
        apache2_conf /vagrant/vagrant/data/web/httpd-ssl.conf $sslconf $webroot $domain
        if ! grep -q NameVirtualHost /etc/httpd/conf.d/ssl.conf; then
            sed -i '/Listen 443/a NameVirtualHost *:443' /etc/httpd/conf.d/ssl.conf
        fi
    fi

    # Restarting httpd service
    service httpd restart >/dev/null 2>&1
fi
