#!/usr/bin/env bash

ansible-galaxy install -r /provision/awx/requirements.yml
ansible-playbook /provision/awx/install.yaml

newgrp docker <<HERE
  ansible-playbook /provision/awx/run.yaml
  echo "Username: admin"
  printf "Password: "
  minikube kubectl -- get secret awx-demo-admin-password --output jsonpath="{.data.password}" | base64 --decode
HERE
