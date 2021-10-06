#!/usr/bin/env bash

ansible-playbook /provision/awx/hosts.yaml --extra-vars "minion_ip=$1 minion_host=$2"
