#!/bin/bash

timezone="$1"
fixtures="$2"

# Make sure to stop server
service mysql stop

# Copy configuration file
cp /vagrant/vagrant/data/database/my.cnf /etc/my.cnf

# Update timezone
oldTZ=$TZ
TZ=":$timezone"
mysqlTimezone=$(date +%:z)
TZ=oldTZ
sed -i -e "s@:timezone:@$mysqlTimezone@" /etc/my.cnf

# Restart server
service mysql start
chkconfig mysql on

# Load fixtures
mysql -u root <<< "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
if [ "$fixtures" != "" ] && [ -f $fixtures ]; then
    echo 'Loading fixtures'
    mysql -u root < $fixtures
fi
