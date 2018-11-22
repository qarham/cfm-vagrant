# Provisioning of Contrail Multi-Cloud via contrail-multicloud-deployer




## 1. Add Servers

You can add servers one by one or in bulk. In case of bulk server add use following file.

```bash
wget wget https://raw.githubusercontent.com/qarham/cfm-vagrant/master/cfm-1x1-vqfx-8srv-mcloud/k8s-examples/pods/ubuntu.contrail-aws-VN-01.yaml

wget https://raw.githubusercontent.com/qarham/cfm-vagrant/master/cfm-1x1-vqfx-8srv-mcloud/k8s-examples/pods/ubuntu.contrail-az-VN-02.yaml

 ```



```bash
kubectl exec -it ubuntu-aws-vn01 bash
root@ubuntu-aws-vn01:/# ping 10.1.1.3
PING 10.1.1.3 (10.1.1.3) 56(84) bytes of data.
64 bytes from 10.1.1.3: icmp_seq=1 ttl=64 time=351 ms
64 bytes from 10.1.1.3: icmp_seq=2 ttl=64 time=362 ms
^C
--- 10.1.1.3 ping statistics ---
3 packets transmitted, 2 received, 33% packet loss, time 2002ms
rtt min/avg/max/mdev = 351.948/357.355/362.763/5.440 ms
root@ubuntu-aws-vn01:/# ping 10.1.1.4
PING 10.1.1.4 (10.1.1.4) 56(84) bytes of data.
64 bytes from 10.1.1.4: icmp_seq=1 ttl=64 time=275 ms
64 bytes from 10.1.1.4: icmp_seq=2 ttl=64 time=352 ms
64 bytes from 10.1.1.4: icmp_seq=3 ttl=64 time=386 ms
^C
--- 10.1.1.4 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 275.667/338.435/386.798/46.500 ms
 ```

 


### [Bulk Server Add csv file](../images/1x1-vQFX-8-Servers-Bulk.csv)

![cluster Provisioning](images/mcloud-Add-Servers-Bulk.png)

### References

* <https://github.com/Juniper/contrail-ansible-deployer/wiki>
* https://github.com/Juniper/contrail-command-deployer/wiki/Using-Ansible-to-launch-the-Contrail-Command-Containers
* <https://github.com/Juniper/vqfx10k-vagrant>