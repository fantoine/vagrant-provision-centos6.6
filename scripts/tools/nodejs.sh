#!/bin/bash

read -a libraries <<< "$1"

if ! yum list installed nodejs >/dev/null 2>&1; then
    echo 'Installing NodeJS'
    curl -sL https://rpm.nodesource.com/setup | bash -
    yum install -y nodejs

    # Install libraries
    npm install -g ${libraries[@]}
fi
