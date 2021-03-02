#!/bin/bash

# usage
usage() {
   cat << EOF
Usage: sudo install-ansible.sh -u <username>
EOF
   exit 1
}

# verify if user is root
if [ "$(id -u)" -ne 0 ]; then
   echo "Error: Use sudo to run this script."
   exit 1
fi

# verify parameters
if [ $# -ne 2 ]; then
   usage
fi

# get options
while getopts ":u:" opt
do
   case $opt in
      u) 
         username=$OPTARG;;
      \?)
         echo "Invalid option: $OPTARG"
         exit 1;;
      :)
         echo "Option -$opt needs a argument"
         exit;;
   esac
done

# install ansible
#apt-add-repository --yes --update ppa:ansible/ansible
apt update
apt install software-properties-common
apt install ansible

# install ansible modules
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general

# install python argmcomplete
apt install python3-argcomplete
activate-global-python-argcomplete3

# inventory local machine
printf "\n[local]" | tee -a /etc/ansible/hosts
printf "\n127.0.0.1 ansible_connection=local" | tee -a /etc/ansible/hosts
printf "\n[local:vars]" | tee -a /etc/ansible/hosts
printf "\nansible_python_interpreter=/usr/bin/python3" | tee -a /etc/ansible/hosts
printf "\nusername=$username" | tee -a /etc/ansible/hosts

# test ansible
ansible all -m ping
ansible all -a "/bin/echo hello" --become

# run ansible playbook
ansible-playbook local.yml --ask-become-pass