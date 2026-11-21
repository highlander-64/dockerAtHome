# Role Name

Role name: **setup**

Setup of all systems incl. bash aliases, banner, hostname, docker and nfs share.

## Requirements

Ansible is installed on a Raspberry Pi. Secrets are encrypted with Ansible Vault using a password file. This is not recommended, if you are running your environment not on a trusted local network!

## Role Variables

nfs-server - IP address of NFS server

`setup_git` configures the pull-based deployment on hosts in the `ansible` inventory group:

- `repo_path`: repository destination, default `/home/ansible/dockerAtHome`
- `repo_url`: SSH remote URL
- `branch`: branch to deploy, default `main`
- `marker_path`: file containing the last successfully deployed commit
- `timer_calendar`: systemd calendar expressions controlling deployment checks

The repository directory and marker directory are owned by the `ansible` system user. The timer runs the deployment script as that user; deployment is skipped when the remote commit equals the marker commit or when the repository has local changes.

## Example Playbook

ansible-playbook playbooks/setup_system.yml --check

## License

BSD

## Author Information

Bastard operator from hell
