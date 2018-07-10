# ![alt text](images/cfm-top.png) Installation of Contrail Command


The 1st step after bringing up the topology is the Installation of Contrail Command and for that Contrail Command will be installed on s-srv1. Please follow following steps for installtion and accessing the GUI after the installation.


Note: Contrail Command can be isnatlled on your PC/Laptop or any other machine as well but in our setup we have alocated s-srv1 for Contrail Command

```bash
# Let's 1st install git and ansible SW
yum -y install git ansible-2.4.2.0

cd /root/cfm-vagrant/cfm-1x1-vqfx-7srv
vagrant ssh s-srv1
sudo su
cd /opt

# Git Clone Contrail Command Deployer repo
git clone https://github.com/Juniper/contrail-command-deployer.git

cd contrail-command-deployer
vi config/command_servers.yml

# Add IP address of s-srv1 "192.168.2.10" and TAG for the Contrail Command Container, for our testing we used 5.0-119


# Start Contrail Command Deployment 
ansible-playbook playbooks/deploy.yml
 ```

***Here is recorded screen session for Contrail Command Installation***

[![asciicast](https://asciinema.org/a/vh7WqrGOSbVoHxI4YCd1ohGS2.png)](https://asciinema.org/a/vh7WqrGOSbVoHxI4YCd1ohGS2)

## Contrail Command GUI Access via FoxyProxy

Install Forxyproxy addon for Chrome or FireFox as described on the main README file. Here I am using "chrome" and sharing screenshots of FoxyProxy setting for Chrome

```bash
# 1st step is open SSH session to the host node 
ssh root@10.87.65.30 -D 1080
 ```

![Contrail Command GUI](images/FoxyProxy-Chrome-Setttings.png)

Select Configured option on the right hand side at the yop of Chrome bar and just browse normally using s-srv1 IP 192.168.2.10 at port 9091

* https://192.168.2.10:9091
    * Username/Password: admin/contrail123

![Contrail Command GUI](images/FoxyProxy-Contrail-Command-UI.png)

### References

* <https://github.com/Juniper/contrail-ansible-deployer/wiki>
* <https://github.com/Juniper/vqfx10k-vagrant>