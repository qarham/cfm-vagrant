#!/bin/bash -eux

#login as root
sudo echo "nameserver 66.129.255.62" > /etc/resolv.conf

sudo yum update -y
sudo yum install -y epel-release
sudo yum install -y ntp git python-urllib3 git ansible-2.4.2.0 pciutils wget \
  tcpdump net-tools python-pip python-boto python2-boto3

sudo rm -rf /etc/ntp.conf
sudo touch /etc/ntp.conf
sudo echo "driftfile /var/lib/ntp/drift" >> /etc/ntp.conf
sudo echo "server 66.129.255.62" >> /etc/ntp.conf
sudo echo "restrict 127.0.0.1" >> /etc/ntp.conf
sudo echo "restrict -6 ::1" >> /etc/ntp.conf
sudo echo "includefile /etc/ntp/crypto/pw" >> /etc/ntp.conf
sudo echo "keys /etc/ntp/keys" >> /etc/ntp.conf
sudo systemctl start ntpd
sudo systemctl enable ntpd
