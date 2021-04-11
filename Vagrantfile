Vagrant.require_version ">= 2.2.14"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    masters=[
      {
        :hostname => "masternode",
        :box => "bento/ubuntu-18.04",
        :ip => "192.168.55.101",
        :ssh_port => '2221'
      }
    ]

    workers=[
      {
        :hostname => "workernode1",
        :box => "bento/ubuntu-18.04",
        :ip => "192.168.55.102",
        :ssh_port => '2222'
      },
      {
        :hostname => "workernode2",
        :box => "bento/ubuntu-18.04",
        :ip => "192.168.55.103",
        :ssh_port => '2223'
      }
    ]
    
    masters.each do |machine|
      config.vm.define machine[:hostname] do |node|
        node.vm.box = machine[:box]
        node.vm.hostname = machine[:hostname]
      
        node.vm.network :private_network, ip: machine[:ip]
        node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"

        node.vm.provider :virtualbox do |v|
          v.customize ["modifyvm", :id, "--memory", 2048,"--cpus", 2]
          v.customize ["modifyvm", :id, "--name", machine[:hostname]]
        end

        node.vm.provision :shell, privileged: true, path: "./install.sh"
        node.vm.provision :shell, privileged: false, path: "./control-plane.sh"     
        
      end  
    end
    
    workers.each do |machine|
      config.vm.define machine[:hostname] do |node|
        node.vm.box = machine[:box]
        node.vm.hostname = machine[:hostname]
      
        node.vm.network :private_network, ip: machine[:ip]
        node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"
 
        node.vm.provider :virtualbox do |v|
          v.customize ["modifyvm", :id, "--memory", 1024,"--cpus", 1]
          v.customize ["modifyvm", :id, "--name", machine[:hostname]]
        end
        node.vm.provision :shell, privileged: true, path: "./install.sh"
        node.vm.provision :shell, privileged: true, inline: <<-SHELL
          /vagrant/join.sh
        SHELL

      end  
    end

  end