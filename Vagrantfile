# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
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

    awx.vm.provision "shell", path: "provision/scripts/install-ansible.sh"
    awx.vm.provision "shell", privileged: false, path: "provision/scripts/ansible-wrapper.sh"
  end
end
