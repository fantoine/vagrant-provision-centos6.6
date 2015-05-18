#!/bin/bash

if ! yum list installed mongodb-org >/dev/null 2>&1; then
    echo 'Installing MongoDB'

    cat > /etc/yum.repos.d/mongodb-org-3.0.repo <<- CONTENT
[mongodb-org-3.0]
name=MongoDB Repository
baseurl=http://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.0/x86_64/
gpgcheck=0
enabled=1
CONTENT
    yum install -y mongodb-org >/dev/null 2>&1
    chkconfig mongod on >/dev/null 2>&1

    # Restart MongoDB
    service mongod restart >/dev/null 2>&1
fi
