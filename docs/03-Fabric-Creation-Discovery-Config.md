# Creation of Fabric via Contrail Command UI


## 1. Create Fabric

In our case vQFX is already created via Vagrant so please use "Existing "

![Fabric Creation](/cfm-1vqfx-5srv/docs/images/Fabric-Creation-01.png)

![Fabric Creation](/cfm-1vqfx-5srv/docs/images/Fabric-Creation-02.png)


## 2. Fabric Discovery

![Fabric Creation](/cfm-1vqfx-5srv/docs/images/Fabric-Discovery-Start-01.png)

![Fabric Creation](/cfm-1vqfx-5srv/docs/images/Fabric-Discovery-Start-02.png)

![Fabric Creation](/cfm-1vqfx-5srv/docs/images/Fabric-Discovery-Complete.png)

Check following logs during discovery

```bash
tail -200f /var/log/contrail/contrail-fabric-ansible-playbooks.log

tail -200f /var/log/contrail/contrail-fabric-ansible.log
 ```

## 3. Fabric Onboarding

![Fabric Creation](/cfm-1vqfx-5srv/docs/images/Fabric-Onboarding-Start.png)

![Fabric Creation](/cfm-1vqfx-5srv/docs/images/Fabric-Onboarding-Complete-01.png)

![Fabric Creation](/cfm-1vqfx-5srv/docs/images/Fabric-Onboarding-Complete-02.png)



Check following logs during discovery

```bash
tail -200f /var/log/contrail/contrail-fabric-ansible-playbooks.log

tail -200f /var/log/contrail/contrail-fabric-ansible.log
 ```


## 4. vQFX Role and Basic Config

![Fabric Creation](/cfm-1vqfx-5srv/docs/images/Fabric-vQFX-Role-Config.png)

```bash
vagrant@vqfx> show configuration groups | display set
set groups __contrail__ interfaces lo0 unit 0 family inet address 1.1.1.1/32 primary
set groups __contrail__ interfaces lo0 unit 0 family inet address 1.1.1.1/32 preferred
set groups __contrail__ routing-options router-id 1.1.1.1
set groups __contrail__ routing-options route-distinguisher-id 1.1.1.1
set groups __contrail__ routing-options autonomous-system 64512
set groups __contrail__ routing-options resolution rib bgp.rtarget.0 resolution-ribs inet.0
set groups __contrail__ protocols bgp group _contrail_asn-64512 type internal
set groups __contrail__ protocols bgp group _contrail_asn-64512 local-address 1.1.1.1
set groups __contrail__ protocols bgp group _contrail_asn-64512 hold-time 90
set groups __contrail__ protocols bgp group _contrail_asn-64512 family evpn signaling
set groups __contrail__ protocols bgp group _contrail_asn-64512 family route-target
set groups __contrail__ protocols bgp group _contrail_asn-64512 neighbor 172.16.1.101 peer-as 64512
set groups __contrail__ policy-options community _contrail_switch_policy_ members target:64512:1
set groups __contrail__ switch-options vtep-source-interface lo0.0

{master:0}
vagrant@vqfx> show bgp summary
Groups: 1 Peers: 1 Down peers: 0
Table          Tot Paths  Act Paths Suppressed    History Damp State    Pending
bgp.rtarget.0
                       7          7          0          0          0          0
bgp.evpn.0
                       0          0          0          0          0          0
Peer                     AS      InPkt     OutPkt    OutQ   Flaps Last Up/Dwn State|#Active/Received/Accepted/Damped...
172.16.1.101          64512         13         12       0       0        4:31 Establ
  bgp.rtarget.0: 7/7/7/0
  bgp.evpn.0: 0/0/0/0

{master:0}
vagrant@vqfx>
 ```


## 5. vQFX system Config NTP & TimeZone

![Fabric Creation](/cfm-1vqfx-5srv/docs/images/Fabric-vQFX-Basic-Config.png)

```bash
set system time-zone US/Pacific
set system ntp server 172.21.200.60
 ```

## 6. Verify BGP Control Plane

Now let's verify after configuring vQFX in leaf role with basic config BGP session is up with Contrail Controller

```bash
show bgp summary
Groups: 1 Peers: 1 Down peers: 0
Table          Tot Paths  Act Paths Suppressed    History Damp State    Pending
bgp.rtarget.0
                       7          7          0          0          0          0
bgp.evpn.0
                       0          0          0          0          0          0
Peer                     AS      InPkt     OutPkt    OutQ   Flaps Last Up/Dwn State|#Active/Received/Accepted/Damped...
172.16.1.101          64512         27         28       0       0       11:35 Establ
  bgp.rtarget.0: 7/7/7/0
  bgp.evpn.0: 0/0/0/0

 ```

### References

* <https://github.com/Juniper/contrail-ansible-deployer/wiki>
* <https://github.com/Juniper/vqfx10k-vagrant>