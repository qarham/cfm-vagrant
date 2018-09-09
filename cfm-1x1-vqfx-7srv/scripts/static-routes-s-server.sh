sudo cat > /etc/sysconfig/network-scripts/route-eth2 <<EOF
ADDRESS0=172.16.2.0
GATEWAY0=172.16.1.1
NETMASK0=255.255.255.0
ADDRESS1=2.2.2.0
GATEWAY1=172.16.1.1
NETMASK1=255.255.255.0
EOF

sudo systemctl restart network
