# Creation of Fabric via Contrail Command UI


## 1. Create Fabric

In our case vQFXs are already created via Vagrant so please use "Existing "

![Fabric Creation](images/Fabric-Creation-01.png)

![Fabric Creation](images/Fabric-Creation-02.png)


## 2. Fabric Discovery

![Fabric Creation](images/Fabric-Discovery-Start-01.png)

![Fabric Creation](images/Fabric-Discovery-Start-02.png)

![Fabric Creation](images/Fabric-Discovery-Complete.png)

Check following logs during discovery

```bash
tail -200f /var/log/contrail/contrail-fabric-ansible-playbooks.log

tail -200f /var/log/contrail/contrail-fabric-ansible.log
 ```

## 3. Fabric Onboarding

![Fabric Creation](images/Fabric-Onboarding-Start.png)

![Fabric Creation](images/Fabric-Onboarding-Complete-01.png)

![Fabric Creation](images/Fabric-Onboarding-Complete-02.png)



Check following logs during discovery

```bash
tail -200f /var/log/contrail/contrail-fabric-ansible-playbooks.log

tail -200f /var/log/contrail/contrail-fabric-ansible.log
 ```

## 4. Basic Fabric Configuration (BGP Routers Add)

This is the third mandatory step which will add BGP Routers on Contrail Controller end and also configrue the vQFXs with BGP configuration.

![Fabric Creation](images/Fabric-Configure-01.png)

Once Fabric Configuration is completed you can check new BGP Routers under Cluster-----> advance options

![Fabric Creation](images/Fabric-Configure-02.png)

Along with NTP server IP and TimeZone configuration addition to the each vQFX box following configs are also added. 

***vQFX1 Config Changes***
```bash
vagrant@vqfx1> show configuration groups | display set    
set groups __contrail__ interfaces lo0 unit 0 family inet address 2.2.2.1/32 primary
set groups __contrail__ interfaces lo0 unit 0 family inet address 2.2.2.1/32 preferred
set groups __contrail__ routing-options router-id 2.2.2.1
set groups __contrail__ routing-options route-distinguisher-id 2.2.2.1
set groups __contrail__ routing-options autonomous-system 64512
set groups __contrail__ routing-options resolution rib bgp.rtarget.0 resolution-ribs inet.0
set groups __contrail__ protocols bgp group _contrail_asn-64512 type internal
set groups __contrail__ protocols bgp group _contrail_asn-64512 local-address 2.2.2.1
set groups __contrail__ protocols bgp group _contrail_asn-64512 hold-time 90
set groups __contrail__ protocols bgp group _contrail_asn-64512 family evpn signaling
set groups __contrail__ protocols bgp group _contrail_asn-64512 family route-target
set groups __contrail__ protocols bgp group _contrail_asn-64512 neighbor 172.16.1.102 peer-as 64512
set groups __contrail__ protocols bgp group _contrail_asn-64512 neighbor 2.2.2.2 peer-as 64512
set groups __contrail__ policy-options community _contrail_switch_policy_ members target:64512:1
set groups __contrail__ switch-options vtep-source-interface lo0.0

{master:0}
vagrant@vqfx1> show bgp summary 
Groups: 2 Peers: 3 Down peers: 0
Table          Tot Paths  Act Paths Suppressed    History Damp State    Pending
bgp.rtarget.0        
                       7          7          0          0          0          0
inet.0               
                       2          2          0          0          0          0
bgp.evpn.0           
                       0          0          0          0          0          0
Peer                     AS      InPkt     OutPkt    OutQ   Flaps Last Up/Dwn State|#Active/Received/Accepted/Damped...
2.2.2.2               64512         16         15       0       0        5:55 Establ
  bgp.rtarget.0: 0/0/0/0
  bgp.evpn.0: 0/0/0/0
10.0.0.2              64501        955        954       0       0     7:07:09 Establ
  inet.0: 2/2/2/0
172.16.1.102          64512         17         17       0       0        6:46 Establ
  bgp.rtarget.0: 7/7/7/0
  bgp.evpn.0: 0/0/0/0
 ```

***vQFX2 Config Changes***
```bash
vagrant@vqfx2> show configuration groups | display set 
set groups __contrail__ interfaces lo0 unit 0 family inet address 2.2.2.2/32 primary
set groups __contrail__ interfaces lo0 unit 0 family inet address 2.2.2.2/32 preferred
set groups __contrail__ routing-options router-id 2.2.2.2
set groups __contrail__ routing-options route-distinguisher-id 2.2.2.2
set groups __contrail__ routing-options autonomous-system 64512
set groups __contrail__ routing-options resolution rib bgp.rtarget.0 resolution-ribs inet.0
set groups __contrail__ protocols bgp group _contrail_asn-64512 type internal
set groups __contrail__ protocols bgp group _contrail_asn-64512 local-address 2.2.2.2
set groups __contrail__ protocols bgp group _contrail_asn-64512 hold-time 90
set groups __contrail__ protocols bgp group _contrail_asn-64512 family evpn signaling
set groups __contrail__ protocols bgp group _contrail_asn-64512 family route-target
set groups __contrail__ protocols bgp group _contrail_asn-64512 neighbor 172.16.1.102 peer-as 64512
set groups __contrail__ protocols bgp group _contrail_asn-64512 neighbor 2.2.2.1 peer-as 64512
set groups __contrail__ policy-options community _contrail_switch_policy_ members target:64512:1
set groups __contrail__ switch-options vtep-source-interface lo0.0

{master:0}
vagrant@vqfx2> show bgp summary 
Groups: 2 Peers: 3 Down peers: 0
Table          Tot Paths  Act Paths Suppressed    History Damp State    Pending
bgp.rtarget.0        
                       7          7          0          0          0          0
inet.0               
                       2          2          0          0          0          0
bgp.evpn.0           
                       0          0          0          0          0          0
Peer                     AS      InPkt     OutPkt    OutQ   Flaps Last Up/Dwn State|#Active/Received/Accepted/Damped...
2.2.2.1               64512         27         26       0       0       10:50 Establ
  bgp.rtarget.0: 0/0/0/0
  bgp.evpn.0: 0/0/0/0
10.0.0.1              64601        966        965       0       0     7:12:05 Establ
  inet.0: 2/2/2/0
172.16.1.102          64512         25         25       0       0       10:49 Establ
  bgp.rtarget.0: 7/7/7/0
  bgp.evpn.0: 0/0/0/0
 ```

Check following logs during Fabric Configure process.

```bash
tail -200f /var/log/contrail/contrail-fabric-ansible-playbooks.log

tail -200f /var/log/contrail/contrail-fabric-ansible.log
 ```

## 5. vQFX system Config NTP & TimeZone

![Fabric Creation](images/Fabric-vQFX-Basic-Config.png)

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