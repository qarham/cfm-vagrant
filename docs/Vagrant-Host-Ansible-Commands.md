# How to check Contrail Cluster status from Host using ansible?


Here are couple of commands to test Clsuter status and run from host for status update:

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
