#!/bin/bash -eux

#!/bin/bash -eux

# This script will perform following actions:
# - install OpenStack client
# - Download and Add cirros images
# - Create VM flavors
# - Create TWO VNs VN01: 10.1.1.0/24 & VN02: 20.1.1.0/24
# - Instantiate one VM in each VNs (VN01 & VN02)

yum install -y wget gcc python-devel
pip install --upgrade setuptools
pip install python-openstackclient
pip install python-ironicclient
pip install python-neutronclient
pip install python-heatclient

# Check Contrail Status
contrail-status

source /etc/kolla/kolla-toolbox/admin-openrc.sh
#source /etc/kolla/admin-openrc.sh

#download Cirros image
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
openstack image create cirros2 --disk-format qcow2 --public --container-format bare --file cirros-0.4.0-x86_64-disk.img

#download lab Ubunt image
#wget  http://10.10.16.104/trusty-server-cloudimg-amd64-disk1.img
#openstack image create --disk-format qcow2 --container-format bare --public --file trusty-server-cloudimg-amd64-disk1.img ubuntu-lab

# Download Cirros Servcie Chaining Image
wget https://raw.githubusercontent.com/qarham/tf-os-k8s-vagrant/master/heat/cirros-sc-3-IFs.img
openstack image create cirrossc --disk-format qcow2 --public --container-format bare --file cirros-sc-3-IFs.img

#Create flavors
openstack flavor create --ram 512 --disk 1 --vcpus 1 m1.tiny
openstack flavor create --ram 2048 --disk 5 --vcpus 1 m1.small

# validation
openstack image list
openstack flavor list



