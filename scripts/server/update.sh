#!/bin/bash

# Update OS
echo 'Updating OS'
yum update -y

# Install some tools
echo 'Installing tools'
yum install -y kernel-devel gcc nano vim git curl htop wget zip unzip

# Force virtualbox guest rebuild
echo 'Rebuilding VirtualBox Guest Additions'
/etc/init.d/vboxadd setup
