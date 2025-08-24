# Role Name

Role name: **setup**

Setup of all systems incl. bash aliases, banner, hostname, docker and nfs share.

## Requirements

Ansible is installed on a Raspberry Pi. Secrets are encrypted with Ansible Vault using a password file. This is not recommended, if you are running your environment not on a trusted local network!

## Role Variables

nfs-server - IP address of nfs server

## Example Playbook

ansible-playbook playbooks/setup_system.yml --check

## License

BSD

## Author Information

Bastard operator from hell
