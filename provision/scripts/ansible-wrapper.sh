#!/usr/bin/env bash

ansible-galaxy install -r /provision/requirements.yml
ansible-playbook /provision/install.yaml

newgrp docker <<HERE
  ansible-playbook /provision/run.yaml
  echo "Username: admin"
  printf "Password: "
  minikube kubectl -- get secret awx-demo-admin-password --output jsonpath="{.data.password}" | base64 --decode
HERE
