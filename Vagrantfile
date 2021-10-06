# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  minions=[
    { :hostname => "minion1", :ip => "192.168.33.11" },
    { :hostname => "minion2", :ip => "192.168.33.12" },
    { :hostname => "minion3", :ip => "192.168.33.13" }
  ]

  config.vm.define "awx", primary: true do |awx|
    awx.vm.box = "ubuntu/focal64"
    awx.vm.network "private_network", ip: "192.168.33.10"
    awx.vm.synced_folder "./app", "/app"
    awx.vm.synced_folder "./provision", "/provision"

    awx.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = "8192"
      vb.cpus = "4"
    end

    awx.vm.provision "shell", path: "provision/awx/scripts/install-ansible.sh"
    awx.vm.provision "shell", privileged: false, path: "provision/awx/scripts/ansible-wrapper.sh"

    minions.each do |minion|
      awx.vm.provision "shell", privileged: false, path: "provision/awx/scripts/hosts.sh", args: [minion[:ip],minion[:hostname]]
    end

    awx.trigger.after :up do |trigger|
      trigger.run = { inline:
        "vagrant ssh awx -- cp /home/vagrant/.ssh/id_rsa.pub /vagrant/.vagrant/machines/awx/virtualbox/id_rsa.pub"
      }
    end
  end

  minions.each do |minion|
    config.vm.define minion[:hostname] do |node|
      node.vm.box = "ubuntu/focal64"
      node.vm.hostname = minion[:hostname]
      node.vm.network "private_network", ip: minion[:ip]
      node.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.memory = "2048"
        vb.cpus = "1"
      end

      node.trigger.after :up do |trigger|
        trigger.run = { inline:
          "vagrant ssh " + minion[:hostname] + " -- cat /vagrant/.vagrant/machines/awx/virtualbox/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys"
        }
      end
    end
  end
end
