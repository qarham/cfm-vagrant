# ![Logo](docs/images/cfm-logo-small.png) Contrail Fabric Manager Vagrant Setup

This repo is created for quick CFM poc/demo setup using Vagrant on a single Host "BMS" Bare Matel Server. If you are interested in setting up basic 1x1 Spine & leaf Fabric with couple of VM nodes for CFM use-cases demo/poc this repo will guide you in setting up topology and provide setp by step instructions for topology creation, installation of SW and E2E testing different use cases.

***High Level Topology Diagram***
 (1x1 vQFX Spine & Leaf with 7 Nodes)

![CFM Topology](cfm-1x1-vqfx-7srv/images/cfm-1x1vQFX-Top-Overview.png)

***Detail Topology Diagram***
![CFM Topology](cfm-1x1-vqfx-7srv/images/cfm-1x1vQFX-Full-Top.png)

The main code of this repository is taken from [Juniper/vqfx10k-vagrant](https://github.com/Juniper/vqfx10k-vagrant) to create a Testbed for CFM testing. Using this repo you can create a topology captured in the above diagram for basic CFM use-cases testing.

* 2 vQFX 10K
* 7 VMs CentOS 7.5 
  * 1 Contrail-Command
  * 1 OpenStack/Contrail Controller
  * 1 CSN "Contrail Service Node"
  * 2 Compute nodes
  * 2 BMS (Non-LCM)

Frist step is prepartion of host machine and the host can be running an Ubuntu or CentOS OS, please follow "Host Server Vagrant Setup" section for detail instructions.

## Host Server Vagrant Setup (prerequisite)

***Note: Please use dedicated BMS for the setup and BMS tested for this setup has following resources  "24 CPUs, RAM:256GB, 750GB-1TB HDD"***

1. Install Ubuntu 16.04.3 or CentOS 7.5 OS on the BMS and install following software using scripts provided under folder "scripts".

    * Vagrant 2.1.1
    * Python 2.7.5
    * VirtualBox 5.2
    * Ansible 2.6.2

```bash
yum install -y git
cd /root
git clone https://github.com/qarham/cfm-vagrant.git
cd cfm-vagrant/scripts
chmod +x setup_*

## Run script as per your OS for SW installation
./setup_vagrant_centos.sh
or
./setup_vagrant_ubuntu.sh

## Now verify the SW installation using following command
vboxmanage --version
  5.2.12r122591

vagrant --version
  Vagrant 2.1.1

ansible --version
   ansible 2.5.3

pip list | grep junos
&
pip list | grep jxmlease

ansible-galaxy list
  - Juniper.junos, 2.1.0

 ```

2. Now after sucessful installtion of SW let's download and add all Vagrant boxes requried for the setup.

Note: This step will speed up creation of whole setup topology.

```bash
cd /var/tmp
# Download vqfx re and pfe boxes from following link
wget http://10.84.5.120/cs-shared/images/vagrant-boxes/vqfx-re-virtualbox.box
wget http://10.84.5.120/cs-shared/images/vagrant-boxes/vqfx10k-pfe-virtualbox.box 

# Add vagrant boxes using following command
vagrant box add --name juniper/vqfx10k-re /var/tmp/vqfx-re-virtualbox.box
vagrant box add --name juniper/vqfx10k-pfe /var/tmp/vqfx10k-pfe-virtualbox.box

# Download CentOS 350GB Box from Vagrant Cloud, specially created for Contrail disk size requirmenet
vagrant box add qarham/CentOS7.5-350GB

# Check all the boxes added successfully and available 
vagrant box list
    juniper/vqfx10k-pfe    (virtualbox, 0)
    juniper/vqfx10k-re     (virtualbox, 0)
    qarham/CentOS7.5-350GB (virtualbox, 1.0)
 ```

## 1x1 vQFX and 7 nodes Setup (Bringing Up)

After sucessful installtion of prerequisite SW and adding vagrant boxes now it's time bringing up the whole topology up and running. Please follow below steps:

```bash
cd /root/cfm-vagrant/cfm-1x1-vqfx-7srv/

# check status of all nodes and make sure no errors
vagrant status

# Bring the whole topology up
vagrant up

# Note above command will take approx 20-30 min to bring the whole setup up as per topology captured in high-level and detail diagramns

# Check all the nodes are up 
vagrant status

# Login to s-srv1 and test connectivity to leaf,spine and other node
vagrant ssh s-srv1

ping 2.2.2.1  (Connection to vQFX spine)
ping 2.2.2.2 (Connection to vQFX leaf)
ping 172.16.2.101-103 (Connection to nodes connected to vQFX leaf)

# Login to vQFX1 spine for setup validation
vagrant ssh vqfx1

show bgp summary
show route advertise-protocol bgp 10.0.0.2
show route receive-protocol bgp 10.0.0.2

ping 2.2.2.2
ping 172.16.1.101 & 102
ping 172.16.2.101 - 103
 ```

Now after brining setup up and basic validation it's time to start installing Contrail CFM SW and basic use-cases testing. All validated use-cases are documented under folder "docs" and use following link for step to setp installations and validation.

## Use-cases Tested on this setup

* ### [UC-01-Contrail_Command_Installtion](docs/01-Install-Contrail-Command.md)

* ### [UC-02-OpenStack-Contrail-Cluster-Provisioning](docs/02-OpenStack-Contrail-Cluster-Provisioning.md)

* ### [UC-03-Fabric_Creation_Discovery_Onboarding](docs/03-Fabric-Creation-Discovery-Config.md)

* ### [UC-04-Intra_VN_BMS_VM](docs/04-BMS-VM-Intra-VN.md)

* ### [UC-05-Inter_VNs_BMS_VM](docs/05-BMS-VM-Inter-VN.md)

* ### [UC-06-BM_SecurityGroups](docs/06-BMS-Security.md)

* ### [FoxyProxy for Chrome Setup](docs/FoxyProxy-Chrome-Setup.md)

* ### [Host Ansible Commands for status](docs/Vagrant-Host-Ansible-Commands.md)

### References

* <https://github.com/Juniper/contrail-ansible-deployer/wiki>
* <https://github.com/Juniper/contrail-command-deployer/wiki/Using-Ansible-to-launch-the-Contrail-Command-Containers>
* <https://github.com/Juniper/vqfx10k-vagrant>
* <https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4>