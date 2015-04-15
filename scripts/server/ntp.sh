#!/bin/bash

timezone="$1"

if [ ! -f /etc/ntp.conf ]; then
    echo 'Installing and configuring NTP'
    yum install -y ntp
    ntpdate pool.ntp.org
    chkconfig ntpd on
    service ntpd start

    # Set timezone
    rm -f /etc/localtime
    ln -s /usr/share/zoneinfo/$timezone /etc/localtime

    echo 'NTP is setup and configured'
    echo 'Below should be the correct date:'
    date

    # Replace centos pool with regular NTP pool
    sed -i 's/centos.pool.ntp.org/pool.ntp.org iburst/g' /etc/ntp.conf

    # Add this to not fail on big time gaps ( VMs that resume/pause )
    echo "tinker panic 0" >> /etc/ntp.conf
fi

if [ ! -f /usr/bin/update-time ]; then
    echo 'Creating NTP update utility : update-time'

    # Create a script to update time. 
    cat >/usr/bin/update-time <<EOL
    service ntpd stop
    ntpdate pool.ntp.org
    service ntpd start
EOL

    # Now we can just run "update-time" to restart and sync time servers:
    chmod +x /usr/bin/update-time
fi
