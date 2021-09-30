# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/focal64"
  config.vm.network "private_network", ip: "192.168.33.10"
  #config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.synced_folder "./app", "/app"
  config.vm.synced_folder "./provision", "/provision"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "8192"
    vb.cpus = "4"
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y python3-pip
    pip3 install ansible
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    ansible-galaxy install -r /provision/requirements.yml
    ansible-playbook /provision/install.yaml

    newgrp docker <<HERE
      ansible-playbook /provision/run.yaml
      echo "Username: admin"
      printf "Password: "
      minikube kubectl -- get secret awx-demo-admin-password --output jsonpath="{.data.password}" | base64 --decode
HERE
  SHELL
end
