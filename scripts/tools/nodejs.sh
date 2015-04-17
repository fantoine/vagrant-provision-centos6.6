#!/bin/bash

read -a libraries <<< "$1"

tmpNode=/tmp/nodesetup.sh
if ! yum list installed nodejs >/dev/null 2>&1; then
    echo 'Installing NodeJS'
    wget -O $tmpNode https://rpm.nodesource.com/setup >/dev/null 2>&1
    chmod +x $tmpNode
    $tmpNode >/dev/null 2>&1
    rm $tmpNode
    yum install -y nodejs >/dev/null 2>&1

    # Install libraries
    npm install -g ${libraries[@]} >/dev/null 2>&1
fi
