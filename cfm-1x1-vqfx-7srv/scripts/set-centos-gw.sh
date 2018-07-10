#!/bin/bash -v

sudo sed  -i '/ONBOOT/a DEFROUTE="no"' /etc/sysconfig/network-scripts/ifcfg-eth0
sudo sed  -i '/NETMASK/a GATEWAY=10.87.65.126' /etc/sysconfig/network-scripts/ifcfg-eth1
#sudo sed -i 's/DEFROUTE="yes"/DEFROUTE="no"/' /etc/sysconfig/network-scripts/ifcfg-enp0s3
#sudo sed  -i '/NETMASK/a GATEWAY=10.13.82.1' /etc/sysconfig/network-scripts/ifcfg-enp0s8
sudo ip route add 1.1.1.1/32 via 172.16.1.1
sudo systemctl restart network
