#!/bin/bash

if [ ! -f /etc/yum.repos.d/virtualbox.repo ]; then
    echo 'Installing VirtualBox repository'
    wget -O /etc/yum.repos.d/virtualbox.repo http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo >/dev/null 2>&1
    sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/virtualbox.repo
fi

if [ ! -f /etc/yum.repos.d/rpmforge.repo ]; then
    echo 'Installing RepoForge repository'
    rpm -i http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm >/dev/null 2>&1
    sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/rpmforge.repo
fi

if [ ! -f /etc/yum.repos.d/webtatic.repo ]; then
    echo 'Installing Webtatic repository'
    rpm -i https://mirror.webtatic.com/yum/el6/latest.rpm >/dev/null 2>&1
    sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/webtatic.repo
fi
