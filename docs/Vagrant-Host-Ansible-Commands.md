# How to check Contrail Cluster status from Host using ansible?


Here are couple of commands to test cluster status and run from host for status update:

```bash
# Change working directory
cd cfm-vagrant/cfm-1x1-vqfx-7srv/

# check where ansible inventory file is
cat ansible.cfg

# Disable Host Key check (No password will be requried while running ansible command for target nodes)
export ANSIBLE_HOST_KEY_CHECKING=False

# Check status of NTP on all the servers
ansible -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory all -a "ntpstat"


# Check status of Contrail
ansible -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory s-srv2,s-srv3,l-srv1,l-srv2 -a "sudo contrail-status"

# Check virty-type properly confirgued on compute node (QEMU)
ansible -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory l-srv1,l-srv2 -a "grep -i qemu /etc/kolla/nova-compute/nova.conf"


# Setup Google DNS in case there is an issue with local DNS
ansible -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory s-srv2,s-srv3,l-srv1,l-srv2 -a "sudo sed -i 's/10.0.2.3/8.8.8.8/' /etc/resolv.conf"
ansible -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory s-srv2,s-srv3,l-srv1,l-srv2 -a "cat /etc/resolv.conf"
ansible -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory s-srv2,s-srv3,l-srv1,l-srv2 -a "ping www.google.com -c 2"

 ```

## How to set libvirt virt-type to "qemu"?

```bash
yum install -y crudini
crudini --set /etc/kolla/nova-compute/nova.conf libvirt cpu_mode none
crudini --set /etc/kolla/nova-compute/nova.conf libvirt virt_type qemu
docker restart nova_compute
 ```

## CEM TYPE-5 EVPN Workaround

Use following workaround for EVPN TYPE-5 Inter VNs BMS to VM connectivity issue.

```bash
set groups __contrail_overlay_evpn__ switch-options mac-ip-table-size 65535
commit

deactivate groups __contrail_overlay_evpn__ vlans bd-4 l3-interface
deactivate groups __contrail_overlay_evpn__ vlans bd-5 l3-interface
deactivate groups __contrail_overlay_evpn__ interfaces irb
commit

rollback 1
commit
 ```

## How to locate TOR port and type using LLDP from Node side?

```bash
# Install LLDP package for OS (CentOS is used in below example)
yum install lldpad

# Start the LLDP service
systemctl restart lldpad.service
systemctl status lldpad.service

# Check LLDP message communication and TOR switch info and port detail
lldptool -S -i  ens2f1
lldptool get-tlv -n -i ens2f1
 ```


## How to verify Vagrant infras using util


```bash
ansible-playbook utils.yml

ansible-playbook utils.yml -t ntp
ansible-playbook utils.yml -t verify
ansible-playbook utils.yml -t verify
 ```

```bash
ansible-playbook utils.yml --list-tags

playbook: utils.yml

  play #1 (s-srv1,s-srv2,s-srv3,s-srv4,l-srv1,l-srv2,l-srv3,l-srv4): s-srv1,s-srv2,s-srv3,s-srv4,l-srv1,l-srv2,l-srv3,l-srv4	TAGS: []
      TASK TAGS: [config, configure, dns, epel, iptables, ntp, packages, tools, verify]

  play #2 (l-srv3,l-srv4): l-srv3,l-srv4	TAGS: []
      TASK TAGS: [intf, verify]
 ```


## How to enable debug level for DM for troubelshooting?

 ```bash
 1. docker exec -it config_devicemgr_1 bash
2. vi entrypoint.sh
3. set log_level=SYS_DEBUG
4. exit
5. docker restart config_devicemgr_1
 ```

## How to check which ports are open on VM or Node?

```
yum install -y nmap

nmap -sS 192.168.2.10
 ```

## How to check BMS or VM Node detail using "inxi"?


```
# For Ubuntu OS
sudo apt-get install -y inxi

sudo inxi -Fx

# For CentOS
yum install -y inxi

sudo inxi -Fx
 ```

# How to configure SR-IOV?


```bash
# update /etc/default/grub with this line
export GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on iommu=pt"
sudo -E update-grub
sudo reboot now
cat /proc/cmdline
sudo echo '32' > /sys/class/net/ens3f0/device/sriov_numvfs
sudo ip link show ens3f0 # to verify it worked

# add line to /etc/rc.local so it does this on reboot
sudo echo '32' > /sys/class/net/ens3f0/device/sriov_numvfs

```

# CEM Multi-Cloud Gateway

## How to run multiple "contrail-multicloud-deployer" on same PC for simultaneously provisioning of two clusters?

Normally once you create contrail-mcloud-deployer that will take care of life cycle management of one cluster but there might be a scenarios where you would like to provision another from same PC and would like running another mcloud-deployer. Please follow below instructions to achieve that.

```bash
# Install Docker:
Start docker "service docker restart"

# Create 1st folder "cluster01"
mkdir cluster-01
cd cluster-01

# To git clone master branch
git clone https://github.com/Juniper/contrail-multi-cloud.git
# To git clone R5.0 branch
git clone -b R5.0 https://github.com/Juniper/contrail-multi-cloud.git

# To create deployer use following command with credentials.
./deployer.sh -r sanjuabraham -t 5.0.1 -v $PWD:/root/multicloud -a ,access=key> -s <secret-key> -k 

# Create 2nd folder "cluster-02"
mkdir cluster-01
cd cluster-01

# To git clone master branch
git clone https://github.com/Juniper/contrail-multi-cloud.git
# To git clone R5.0 branch
git clone -b R5.0 https://github.com/Juniper/contrail-multi-cloud.git

# Edit deployer.sh and make following changes:
# Change value of "p" from 2222 to 2223 (New Port)
# Chnage value of "n" from multicloud to "multicloud-new"
grep -i 2223 deployer.sh                                                                          
p=2223

grep -i multicloud-new deployer.sh
n="multicloud-new"

# After that create another deplyer container using normal command with credentials.
./deployer.sh -r sanjuabraham -t 5.0.1 -v $PWD:/root/multicloud -a ,access=key> -s <secret-key> -k 

 ```

## How to copy SSH key to already provisioned cluster before multi-cloud provisioning?

```bash
ssh-copy-id root@10.1.1.100

# Via SSH Proxy to another node
ssh -o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p -q root@10.1.1.100" root@172.16.1.102

```

## How bring MC-GW conatiners up and down?


```bash
# For openvpn SSL
cd /etc/multicloud

# Check status of Conatiner
docker-compose -f openvpn-compose.yml ps
# Bring down the conatiner
docker-compose -f openvpn-compose.yml down
# Bring up the conatiner
docker-compose -f openvpn-compose.yml up -d

# For Bird Container
cd /etc/multicloud/bird

# Check status of the Conatiner
docker-compose -f bird-compose.yml ps
# Bring Down the Conatiner
docker-compose -f bird-compose.yml down
# Bring up the conatiner
docker-compose -f bird-compose.yml up -d
 ```


## How to check MC-GW routes and protocol detail?

```bash
 docker exec bird_bird_1 birdc show protocols all

 docker exec bird_bird_1 birdc show route all
 ```

## How to add a node in existing k8s clsuter MC-GW?

```bash
#To get the token on k8s master  
kubeadm token list

# Now use following command on k8s-node to join the cluster
kubeadm join --token <token> <k8s-node-ip>:6443 --discovery-token-unsafe-skip-ca-verification
 ```