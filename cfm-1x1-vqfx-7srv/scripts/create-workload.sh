#!/bin/bash -eux

# - Instantiate one VM in each VNs (VN01 & VN02) on two separate Compute l-srv1 & l-srv2
source /etc/kolla/kolla-toolbox/admin-openrc.sh

# validation
openstack image list
openstack flavor list
openstack network list

# Create two VNs VN-01 CIDR 10.1.1.0/24 & VN-02 20.1.1.0/24
openstack network create VN-01
openstack subnet create --subnet-range 10.1.1.0/24 --network VN-01 VN01-VN-subnet

openstack network create VN-02
openstack subnet create --subnet-range 20.1.1.0/24 --network VN-02 VN02-VN-subnet

# Create VMs on l-srv1 & l-srv2
openstack server create --flavor m1.tiny --image 'cirros2' \
    --nic net-id=VN-01 \
    --availability-zone nova:l-srv1 \
srv1vmvn01-01

openstack server create --flavor m1.tiny --image 'cirros2' \
    --nic net-id=VN-02 \
    --availability-zone nova:l-srv1 \
srv1vmvn02-01

openstack server create --flavor m1.tiny --image 'cirros2' \
    --nic net-id=VN-01 \
    --availability-zone nova:l-srv2 \
srv2vmvn01-02

openstack server create --flavor m1.tiny --image 'cirros2' \
    --nic net-id=VN-02 \
        --availability-zone nova:l-srv2 \
srv2vmvn02-02

sleep 20

echo "Check VM status"
openstack server list

echo "Finish Creating VMs"





