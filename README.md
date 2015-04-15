# Vagrant provisioner for Centos 6.6

This repository provides a set of shell scripts which allows to
easily and quickly setup and configurates a CentOS 6.6 VM with Vagrant.

## Installing the library

To get the provisioning scripts, you need to copy/checkout the library
on a `vagrant` folder at the root of the folder which will be mounted on Vagrant.

### Prepare Vagrantfile

Copy `/vagrant/Vagrantfile.dist` to '/Vagrantfile' then edit it.

You can change several settings at the top of the file.
** It's not advised to edit the rest of the file**

Options:
- **ip_address** *(required)* : The VM ip address
- **project_name** *(required)* : The project name. Must be only alphanumeric characters.
- **base_path** : The base web path.
- **server_extension** : The server domain extension (eg: mydomain.**local**)
- **server_name** : The server domain nomain (eg: **mydomain**.local)
- **server_aliases** : The server subdomains. Must be an array?

### Prepare server configuration

Copy `/vagrant/config.sh.dist` to '/vagrant/config.sh' then edit it.

Options:
- **TODO**

Make it runnable by running:
```bash
chmod +x vagrant/config.sh
```
