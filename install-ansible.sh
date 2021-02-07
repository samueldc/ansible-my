#!/bin/bash
apt update
apt install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt install ansible

# Argcomplete
apt install python-argcomplete
activate-global-python-argcomplete

# Inventory
printf "[local]\n127.0.0.1 ansible_connection=local" | tee -a /etc/ansible/hosts

# Test Ansible
ansible all -m ping
ansible all -a "/bin/echo hello" --become
