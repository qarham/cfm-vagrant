#!/bin/bash -v

# Basic Packages Install and Enable epel repo

yum --enablerepo=extras install epel-release
yum install -y gcc dkms make qt libgomp patch git wget tcpdump bridge-utils python python-pip
yum install -y kernel-headers kernel-devel binutils glibc-headers glibc-devel font-forge

echo "VirtualBox Install"
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | rpm --import -
wget https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo
mv virtualbox.repo /etc/yum.repos.d/
yum update -y
yum install -y VirtualBox-5.2
/sbin/rcvboxdrv setup

echo " Vagrnat Installation"
wget https://releases.hashicorp.com/vagrant/2.1.1/vagrant_2.1.1_x86_64.rpm
yum install -y vagrant_2.1.1_x86_64.rpm
vagrant plugin install vagrant-vbguest

echo "Ansible Install"
yum install -y ansible
ansible-galaxy install Juniper.junos

echo "JunOS Ansible modules installation"
pip install --upgrade pip
pip install jxmlease
pip install junos-eznc

