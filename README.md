# **Bare-Metal Kubernetes Cluster using Vagrant and Virtualbox**

## **Requirements:**
- Vagrant 2.2.14
- Virtualbox 6.1.18

## **Setup and Cleanup:**

### **1. UP COMMAND:**

Clone this repository and navigate to it:

```shell
$ git clone https://github.com/sandesvitor/bare-metal-kubernetes-cluster.git && cd bare-metal-kubernetes-cluster
```

Check for provisioning status with Vagrant to get the following output:

```shell
$ vagrant status
Current machine states:

masternode                not created (virtualbox)
workernode1               not created (virtualbox)
workernode2               not created (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

Now run **vagrant up** command to provision your infrastructure (be wary of CPU and RAM requirements):

```shell
$ vagrant up
```

Check VMs'status:

```shell
Current machine states:

masternode                running (virtualbox)
workernode1               running (virtualbox)
workernode2               running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

### **2. HALT COMMAND:**

To poweroff the VMs use the **vagrant halt** command:

```shell
$ vagrant halt
```

Check VMs'status:

```shell
Current machine states:

masternode                poweroff (virtualbox)
workernode1               poweroff (virtualbox)
workernode2               poweroff (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

### **3. DESTROY COMMAND:**

If you want to clean up your infrasctructure, use the **vagrant destroy** command (pass *--force* flag to skip confirmation on each VM):

```shell
$ vagrant destroy --force
```

## **Cluster Usage:**

This setup uses Ubuntu VMs to create 1 masternode along with 2 workernodes cluster. For better usage in a local environment, masternode was configured to schedule pods with **kubectl taint** command (if you want to change that, remove the last line of code in the shell script *control-plane.sh* in the root folder of this repository).

*NOTE: this infrastrucutre uses Project Calico as default CNI-plugin for Kubernetes.*

Use **vagrant ssh** command to get a shell into the control-plane VM, and you should be able to start using Kubernetes.

```shell
$ vagrant ssh masternode
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 4.15.0-128-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun Apr 11 04:10:23 UTC 2021

  System load:  1.07              Users logged in:        0
  Usage of /:   5.8% of 61.80GB   IP address for eth0:    10.0.2.15
  Memory usage: 42%               IP address for eth1:    192.168.55.101
  Swap usage:   0%                IP address for docker0: 172.17.0.1
  Processes:    152               IP address for tunl0:   192.168.181.0


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
vagrant@masternode:~$ 
```

To garantee whether everything went well with workernodes joining the control-plane, use **kubectl get nodes** command:

```shell
vagrant@masternode:~$ kubectl get nodes
NAME          STATUS   ROLES                  AGE     VERSION
masternode    Ready    control-plane,master   10m     v1.21.0
workernode1   Ready    <none>                 7m11s   v1.21.0
workernode2   Ready    <none>                 2m43s   v1.21.0
```

---