#!/bin/bash

# Installing sudoers
if [ ! -f /etc/sudoers.d/vagrant ]; then
    echo "Installing sudoers"
    echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant
fi

# Installing login 'cd'
if ! grep -q 'cd /vagrant' /home/vagrant/.bashrc ; then
    echo 'Setup home directory'
    echo 'cd /vagrant' >> /home/vagrant/.bashrc
fi