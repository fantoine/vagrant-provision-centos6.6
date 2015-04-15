#!/bin/bash

read -a gems <<< "$1"

if [ ! -f /usr/local/rvm/bin/rvm ]; then
    echo 'Installing Ruby'
    
    gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

    # Compacting gems
    if [ ${#gems[@]} -ne 0 ]; then
        gemsCmd=$(printf ',%s' "${gems[@]}")
        gemsCmd="--gems=${gemsCmd:1}"
    fi

    # Install RVM/Ruby/RubyGem
    curl -L get.rvm.io | bash -s stable --ruby $gemsCmd
    source /usr/local/rvm/scripts/rvm

    # Source RVM
    echo '# RVM/Ruby/RubyGem' >> /home/vagrant/.bash_rc
    echo 'source /usr/local/rvm/scripts/rvm' >> /home/vagrant/.bash_rc
fi
