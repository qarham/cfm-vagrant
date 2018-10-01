#!/bin/bash -v

apt-get update
apt-get install -y wget git bridge-utils python python-pip tmux apt-transport-https software-properties-common

# VirtualBox Installation
# Add following line in "/etc/apt/sources.list"
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian `lsb_release -cs` contrib"
sudo apt-get update
sudo apt-get -y install virtualbox-5.2

### Vagrant install
wget https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_x86_64.deb
dpkg -i vagrant_2.1.1_x86_64.deb

## Ansible Install
sudo apt-get update
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get -y install ansible
ansible-galaxy install Juniper.junos

## Install JunOS Ansible Module and Python Modules
sudo ansible-galaxy install Juniper.junos

pip install --upgrade pip
sudo apt-get update
pip install jxmlease
pip install junos-eznc

## vQFX Box Addition
cd /var/tmp
wget http://10.84.5.120/cs-shared/images/vagrant-boxes/vqfx-re-virtualbox.box
wget http://10.84.5.120/cs-shared/images/vagrant-boxes/vqfx10k-pfe-virtualbox.box

vagrant box add --name juniper/vqfx10k-re /var/tmp/vqfx-re-virtualbox.box
vagrant box add --name juniper/vqfx10k-pfe /var/tmp/vqfx10k-pfe-virtualbox.box

# Download and Addd CentOS-7.5 Box
vagrant box add qarham/CentOS7.5-350GB


echo "List Box"
vagrant box list
