#!/bin/bash -eux

# Delete already created workload by "creaet-workload.sh" script
source /etc/kolla/kolla-toolbox/admin-openrc.sh

# validation
openstack server list
openstack network list

# Delete VMs on l-srv1 & l-srv2
openstack server delete srv1vmvn01-01 srv1vmvn02-01 srv2vmvn01-02 srv2vmvn02-02

# Delete two VNs VN-01 CIDR 10.1.1.0/24 & VN-02 20.1.1.0/24
openstack network delete VN-01 VN-02
openstack subnet delete VN01-VN-subnet VN02-VN-subnet

echo "Check VM status"
openstack server list
openstack subnet list
openstack network list

echo "Finish Deleting VMs and VNs"





