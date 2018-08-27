#!/bin/bash -eux

sudo bash -c 'cat <<EOF >/etc/resolv.conf
nameserver 8.8.8.8
nameserver 10.0.2.3
EOF'