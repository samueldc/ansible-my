# ansible-my

Tired of configure my home OS after every installation, made this Ansible Playbook to automate that.

# Instructions

Clone this repository.

Install Ansible and add local machine to the inventory using:
sudo install-ansible.sh

Configure local machine using:
ansible-playbook local.yml --ask-become-pass
