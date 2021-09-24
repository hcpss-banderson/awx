# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/focal64"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.synced_folder "./app", "/app"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "8192"
    vb.cpus = "4"
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y docker docker-compose
    curl -LO https://github.com/kubernetes/minikube/releases/download/v1.22.0/minikube_1.22.0-0_amd64.deb
    dpkg -i minikube_1.22.0-0_amd64.deb
    usermod -aG docker vagrant
  SHELL

  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    newgrp docker <<HERE
      minikube delete
      minikube start --addons=ingress --cpus=4 --cni=flannel --install-addons=true --kubernetes-version=stable --memory=6g
      sleep 1m
      minikube kubectl -- apply -f https://raw.githubusercontent.com/ansible/awx-operator/0.13.0/deploy/awx-operator.yaml
      sleep 1m
      minikube kubectl -- apply -f /app/awx-demo.yml
HERE
  SHELL
end
