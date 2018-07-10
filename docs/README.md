# ![alt text](/images/cfm-top.png) Contrail Fabric Manager Testbed setup (1vQFX and 5 VMs) for CFM Testing


![Web Console](/cfm-1vqfx-5srv/docs/images/cfm_vqfx_basic-config.png)

Changes on vQFX side

```bash
show configuration groups __contrail__ | display set 
set groups __contrail__ interfaces lo0 unit 0 family inet address 1.1.1.1/32 primary
set groups __contrail__ interfaces lo0 unit 0 family inet address 1.1.1.1/32 preferred
set groups __contrail__ routing-options router-id 172.16.1.101
set groups __contrail__ routing-options route-distinguisher-id 172.16.1.101
set groups __contrail__ routing-options autonomous-system 64512
set groups __contrail__ routing-options resolution rib bgp.rtarget.0 resolution-ribs inet.0
set groups __contrail__ protocols bgp group _contrail_asn-64512 type internal
set groups __contrail__ protocols bgp group _contrail_asn-64512 local-address 172.16.1.101
set groups __contrail__ protocols bgp group _contrail_asn-64512 hold-time 0
set groups __contrail__ protocols bgp group _contrail_asn-64512 family evpn signaling
set groups __contrail__ protocols bgp group _contrail_asn-64512 family route-target
set groups __contrail__ protocols bgp group _contrail_asn-64512 export _contrail_ibgp_export_policy
set groups __contrail__ policy-options policy-statement _contrail_ibgp_export_policy term inet-vpn from family inet-vpn
set groups __contrail__ policy-options policy-statement _contrail_ibgp_export_policy term inet-vpn then next-hop self
set groups __contrail__ policy-options policy-statement _contrail_ibgp_export_policy term inet6-vpn from family inet6-vpn
set groups __contrail__ policy-options policy-statement _contrail_ibgp_export_policy term inet6-vpn then next-hop self
set groups __contrail__ policy-options community _contrail_switch_policy_ members target:64512:1
set groups __contrail__ switch-options vtep-source-interface lo0.0

 ```


##### 1. Adding No-LCM BMS to Servers List

![Web Console](/cfm-1vqfx-5srv/docs/images/cfm-no-lcm-bms-server-add.png)

##### 2. Create Exiting Baremetal Server Instance 

![Web Console](/cfm-1vqfx-5srv/docs/images/cfm-no-lcam-bms-instance-create.png)

Changes on vQFX side

```bash
vagrant@vqfx> show configuration groups __contrail__
set groups __contrail__ interfaces lo0 unit 0 family inet address 1.1.1.1/32 primary
set groups __contrail__ interfaces lo0 unit 0 family inet address 1.1.1.1/32 preferred
set groups __contrail__ interfaces irb gratuitous-arp-reply
set groups __contrail__ interfaces irb unit 4 proxy-macip-advertisement
set groups __contrail__ interfaces irb unit 4 family inet address 10.1.1.5/24 virtual-gateway-address 10.1.1.1
set groups __contrail__ interfaces xe-0/0/3 flexible-vlan-tagging
set groups __contrail__ interfaces xe-0/0/3 native-vlan-id 4094
set groups __contrail__ interfaces xe-0/0/3 encapsulation extended-vlan-bridge
set groups __contrail__ interfaces xe-0/0/3 unit 0 vlan-id 4094
set groups __contrail__ routing-options router-id 172.16.1.101
set groups __contrail__ routing-options route-distinguisher-id 172.16.1.101
set groups __contrail__ routing-options autonomous-system 64512
set groups __contrail__ routing-options resolution rib bgp.rtarget.0 resolution-ribs inet.0
set groups __contrail__ protocols bgp group _contrail_asn-64512 type internal
set groups __contrail__ protocols bgp group _contrail_asn-64512 local-address 172.16.1.101
set groups __contrail__ protocols bgp group _contrail_asn-64512 hold-time 0
set groups __contrail__ protocols bgp group _contrail_asn-64512 family evpn signaling
set groups __contrail__ protocols bgp group _contrail_asn-64512 family route-target
set groups __contrail__ protocols bgp group _contrail_asn-64512 export _contrail_ibgp_export_policy
set groups __contrail__ protocols evpn vni-options vni 4 vrf-target target:64512:8000002
set groups __contrail__ protocols evpn encapsulation vxlan
set groups __contrail__ protocols evpn default-gateway no-gateway-community
set groups __contrail__ protocols evpn extended-vni-list all
set groups __contrail__ policy-options policy-statement _contrail_ibgp_export_policy term inet-vpn from family inet-vpn
set groups __contrail__ policy-options policy-statement _contrail_ibgp_export_policy term inet-vpn then next-hop self
set groups __contrail__ policy-options policy-statement _contrail_ibgp_export_policy term inet6-vpn from family inet6-vpn
set groups __contrail__ policy-options policy-statement _contrail_ibgp_export_policy term inet6-vpn then next-hop self
set groups __contrail__ policy-options policy-statement _contrail_MGMT-VN-l2-4-export term t1 then community add _contrail_target_64512_8000002
set groups __contrail__ policy-options policy-statement _contrail_MGMT-VN-l2-4-export term t1 then accept
set groups __contrail__ policy-options policy-statement _contrail_MGMT-VN-l2-4-import term _contrail_switch_policy_ from community _contrail_switch_policy_
set groups __contrail__ policy-options policy-statement _contrail_MGMT-VN-l2-4-import term _contrail_switch_policy_ then accept
set groups __contrail__ policy-options policy-statement _contrail_MGMT-VN-l2-4-import term t1 from community _contrail_target_64512_8000002
set groups __contrail__ policy-options policy-statement _contrail_MGMT-VN-l2-4-import term t1 then accept
set groups __contrail__ policy-options community _contrail_target_64512_8000002 members target:64512:8000002
set groups __contrail__ policy-options community _contrail_switch_export_community_ members target:64512:8000002
set groups __contrail__ policy-options community _contrail_switch_policy_ members target:64512:1
set groups __contrail__ switch-options vtep-source-interface lo0.0
set groups __contrail__ switch-options route-distinguisher 172.16.1.101:1
set groups __contrail__ switch-options vrf-import _contrail_MGMT-VN-l2-4-import
set groups __contrail__ switch-options vrf-export _contrail_MGMT-VN-l2-4-export
set groups __contrail__ switch-options vrf-target target:64512:1
set groups __contrail__ switch-options vrf-target auto
set groups __contrail__ vlans contrail_MGMT-VN-l2-4 vlan-id 4
set groups __contrail__ vlans contrail_MGMT-VN-l2-4 interface xe-0/0/3.0
set groups __contrail__ vlans contrail_MGMT-VN-l2-4 l3-interface irb.4
set groups __contrail__ vlans contrail_MGMT-VN-l2-4 vxlan vni 4

 ```


***BMS VLAN config***
VLAN tagging via "ip link" command

```bash
ip link add link eth0 name eth2.100 type vlan id 100
ip link delete eth2.100
 ```


***TSN Node DHCP Packet Capture***

```bash
tcpdump -nei eth2 udp port 4789
20:36:32.818728 02:05:86:71:33:00 > 08:00:27:01:8b:6b, ethertype IPv4 (0x0800), length 392: 1.1.1.1.11519 > 172.16.1.103.4789: VXLAN, flags [I] (0x08), vni 4
08:00:27:ec:c0:f6 > Broadcast, ethertype IPv4 (0x0800), length 342: 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP, Request from 08:00:27:ec:c0:f6, length 300
20:36:32.819241 08:00:27:01:8b:6b > 02:05:86:71:33:00, ethertype IPv4 (0x0800), length 372: 172.16.1.103.63828 > 1.1.1.1.4789: VXLAN, flags [I] (0x08), vni 4
08:00:27:01:8b:6b > 08:00:27:ec:c0:f6, ethertype IPv4 (0x0800), length 322: 10.1.1.2.bootps > 10.1.1.5.bootpc: BOOTP/DHCP, Reply, length 280
 ```


```bash
vagrant@vqfx> show ethernet-switching vxlan-tunnel-end-point remote
Logical System Name       Id  SVTEP-IP         IFL   L3-Idx
<default>                 0   1.1.1.1          lo0.0    0
 RVTEP-IP         IFL-Idx   NH-Id
 172.16.1.102     570       1746
    VNID          MC-Group-IP
    4             0.0.0.0
 RVTEP-IP         IFL-Idx   NH-Id
 172.16.1.103     559       1731
    VNID          MC-Group-IP
    4             0.0.0.0
 ```


The main code of this repository is taken from [Juniper/vqfx10k-vagrant](https://github.com/Juniper/vqfx10k-vagrant) to create a Testbed for CFM testing. Using this repo you can create a topology captured in the above diagram for basic CFM testing.

* 1 vQFX 10K
* 5 VMs CentOS 7.5 
  * 1 Contrail-Command
  * 1 OpenStack/Contrail Controller
  * 1 CSN "Contrail Service Node"
  * 2 Compute nodes
 
**Prerequisites**: A host machine with Ubuntu/CentOS OS preinstalled with Vagrant & VirtualBox SW.


```bash
host> git clone https://github.com/qarham/tf-os-k8s-vagrant.git
host> cd tf-os-k8s-vagrant/cfm-1vqfx-5srv
host> vagrant status
host> vagrantup
```

By default without making any change in "Vagrantfile" above topology will be created. You can change MGMT and Ctrl+Data Subnet in Vagrantfile as needed.

```bash
$subnet_mgmt = "10.87.65"
$subnet_ctrl_data= "172.16.1"
```

### References

* <https://github.com/Juniper/contrail-ansible-deployer/wiki>
* <https://github.com/Juniper/vqfx10k-vagrant>