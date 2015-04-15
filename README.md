# Vagrant provisioner for CentOS 6.6

This repository provides a set of shell scripts which allows to
easily and quickly setup a CentOS 6.6 VM with Vagrant.

## Installing the library

To get the provisioning scripts, you need to copy/checkout the library
on a `vagrant` folder at the root of the folder which will be mounted on Vagrant.

### Prepare Vagrantfile

Copy `<project>/vagrant/Vagrantfile.dist` to `<project>/Vagrantfile` then edit it.

You can change several settings at the top of the file.
**It's not advised to edit the rest of the file, unless you know what you do.**

Options:
- **ip_address** *(required)* : The VM ip address
- **project_name** *(required)* : The project name. Must be only alphanumeric characters.
- **base_path** : The base web path.
- **server_extension** : The server domain extension (eg: mydomain.**local**)
- **server_name** : The server domain nomain (eg: **mydomain**.local)
- **server_aliases** : The server subdomains. Must be an array.

### Prepare server configuration

Copy `<project>/vagrant/config.sh.dist` to `<project>/vagrant/config.sh` then edit it.

Options:
- **TODO**

Make it runnable by running:
```bash
chmod +x vagrant/config.sh
```

### Create ssh keys

You must creates ssh keys to enable SSH authentication per certificate.
It's advised to **NOT** set a passphrase since it will be asked each time
you want to connect to the VM.

To quickly create these keys run:
```bash
ssh-keygen -f <project>/vagrant/ssh/id_rsa -P '' -C 'vagrant'
```

## Creating and provisioning the VM

You have done almost all the job. No you only have to *up* the VM and
the provisioning will be executed automatically.
```bash
vagrant up
```

Since it will be the first time you login to the VM you may be asked to enter
the password for the `vagrant` user.
You only have to enter `vagrant` as the password and wait for provisioning to finish.

## Contribute

Feel free to contribute by pulling new scripts or improvements.
