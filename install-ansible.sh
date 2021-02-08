#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
   echo "Error: Use sudo to run this script."
   exit 1
fi

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

# Install Ansible modules
ansible-galaxy collection install ansible.posix

# Run Ansible
ansible-playbook local.yml --ask-become-pass
