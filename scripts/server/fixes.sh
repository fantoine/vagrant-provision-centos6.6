#!/bin/bash

#Fixing slow curl requests (ipv6 resolving timeouts causing issue)
#See: https://github.com/mitchellh/vagrant/issues/1172
if [ ! "$(grep single-request-reopen /etc/resolv.conf)" ]; then
    echo "Fixing slow curl requests"
    echo 'options single-request-reopen' >> /etc/resolv.conf && service network restart;
fi
