# Installation of Contrail Command

The 1st step after bringing up the topology is the Installation of Contrail Command, and for that Contrail Command will be installed on s-srv1. Please follow the following steps for installation and accessing the GUI after the installation.


Note: Contrail Command can be installed on your PC/Laptop or any other machine as well, but in our setup, we have allocated s-srv1 for Contrail Command

## Contrail Command 5.0.2 GA Procedure

For Contrail Command 5.0.2 GA please follow below steps:

* Install Docker

```bash
host> vagrant ssh s-srv1

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
systemctl start docker
 ```

* Download reference "comman_servers.yml" and update the config as per your environment.

```bash
cd /opt
wget https://raw.githubusercontent.com/qarham/cfm-vagrant/master/docs/scripts/5.0.2/command_servers.yml

# Now please make changes in config file as needed
vi command_servers.yml
 ```

* External Repo "hub.juniper.net"

```bash
# For external use following steps
docker login hub.juniper.net/contrail
# Provide username/password
# Once login pull Contrail Command image using
docker pull hub.juniper.net/contrail/contrail-command-deployer:5.0.2-0.360

# AFter that please use following command to bring contrail command up.  
docker run -t --net host -v /opt/command_servers.yml:/command_servers.yml -d --privileged --name contrail_command_deployer hub.juniper.net/contrail/contrail-command-deployer:5.0.2-0.360
 ```

***Note*** Reference [Contrail Comman Servers File](https://raw.githubusercontent.com/qarham/cfm-vagrant/master/docs/scripts/5.0.2/command_servers.yml)

 Now to check the progress of installation use "docker log" command

 ```bash
docker logs -f contrail_command_deployer
 ```

## Contrail Command GUI Access via FoxyProxy

Please use following links for FoxyProxy Setup and configuration. 

* ### [FoxyProxy Setup for Chrome](FoxyProxy-Chrome-Setup.md)

* ### [FoxyProxy Setup for FireFox](FoxyProxy-FireFox-Setup.md)


```bash
# 1st step is open SSH session to the host node 
ssh root@10.87.65.30 -D 1080
 ```

* https://192.168.2.10:9091
    * Username/Password: admin/contrail123

![Contrail Command GUI](images/FoxyProxy-Contrail-Command-UI.png)

### References

* <https://github.com/Juniper/contrail-ansible-deployer/wiki>
* <https://github.com/Juniper/vqfx10k-vagrant>
* <https://www.juniper.net/documentation/en_US/contrail5.0/topics/task/configuration/import-cluster-data-contrail-command.html>