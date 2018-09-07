***
This Vagrantfile will spawn 3 instances of VQFX (Full) each with 1 Routing Engine and 1 PFE VM along with 7 nodes connected to 1x2 vQFX Fabric.

# Topology

## High Level Topology Diagram

![Web Console](images/cfm-1x2vQFX-Top-Overview.png)

## Low Level Detail Topology Diagram

![Web Console](images/cfm-1x2vQFX-Full-Top.png)

# Provisioning / Configuration

Ansible is used to preconfigured both VQFX with an IP address on their interfaces
