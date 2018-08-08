#!/bin/bash -eux
sudo -i
yum install -y ntp
systemctl start ntpd
systemctl enable ntpd
cat << EOFF > /etc/ntp.conf
server 10.19.6.55 iburst maxpoll 9
driftfile /var/lib/ntp/drift
EOFF
systemctl restart ntpd
sleep 5
systemctl restart ntpd

