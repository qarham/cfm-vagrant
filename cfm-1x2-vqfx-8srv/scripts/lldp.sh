#!/bin/bash
#

sudo yum -y install lldpad

sudo systemctl start lldpad
sudo systemctl enable lldpad

for i in $(ls /sys/class/net/ | grep 'eth\|ens\|eno') ;
      do echo "enabling lldp for interface: $i" ;
      sudo lldptool set-lldp -i $i adminStatus=rxtx  ;
      sudo lldptool -T -i $i -V  sysName enableTx=yes;
      sudo lldptool -T -i $i -V  portDesc enableTx=yes ;
      sudo lldptool -T -i $i -V  sysDesc enableTx=yes;
      sudo lldptool -T -i $i -V sysCap enableTx=yes;
      sudo lldptool -T -i $i -V mngAddr enableTx=yes;
done
