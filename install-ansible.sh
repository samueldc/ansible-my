#!/bin/bash
set -e

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
apt update
apt install -y ansible

# install ansible modules
echo "Installing Ansible collections..."
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general

# install python3-argcomplete if available (optional)
if apt-cache search python3-argcomplete | grep -q "^python3-argcomplete"; then
   apt install -y python3-argcomplete
   activate-global-python-argcomplete3 2>/dev/null || true
fi

# create inventory directory if it doesn't exist
mkdir -p /etc/ansible/hosts.d/

# inventory local machine in dedicated file
cat > /etc/ansible/hosts.d/localhost.ini << 'INVENTORY'
[local]
127.0.0.1 ansible_connection=local

[local:vars]
ansible_python_interpreter=/usr/bin/python3
INVENTORY

# append username variable
echo "username=$username" >> /etc/ansible/hosts.d/localhost.ini

# test ansible
echo "Testing Ansible installation..."
ansible all -m ping
ansible all -a "/bin/echo hello" --become

echo "Ansible installation completed successfully!"

# run ansible playbook
ansible-playbook local.yml --ask-become-pass