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

source /etc/kolla/admin-openrc.sh

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

# Create Test VM and Test vRouter Connection
openstack network create VN-01
openstack subnet create --subnet-range 10.1.1.0/24 --network VN-01 VN01-VN-subnet

openstack network create VN-02
openstack subnet create --subnet-range 20.1.1.0/24 --network VN-02 VN02-VN-subnet

openstack server create --flavor m1.tiny --image 'cirros2' \
    --nic net-id=VN-01 \
    --availability-zone nova:srv2 \
VM-01

openstack server create --flavor m1.tiny --image 'cirros2' \
    --nic net-id=VN-02 \
        --availability-zone nova:srv2 \
VM-02