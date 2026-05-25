# Role Name

Role name: **docker**

Installation and update of different applications based on docker using docker compose files.

## Requirements

Ansible is installed on a Raspberry Pi. Secrets are encrypted with Ansible Vault using a password file. This is not recommended, if you are running your environment not on a trusted local network!

## Role Variables

main:  

    hostname:                  - name of target host, e. g. jarvis.fritz.box  
    docker_id:                 - UserID and group ID of docker user, e. g. 1002:100  
    docker-compose-files-path: - base path of docker compose files, for each application, the subfolder will be created in this directory, e. g. /srv/docker/docker/  
    docker-data-path:          - path of your data directory for mounted docker volumes, e. g. /srv/docker/data/

fritzbox_exporter:  

    user:                      - username of fritzbox user to gather metrics, e.g .monitor  
    password:                  - password of fritzbox user, encrypted with Ansible Vault  
    gateway:                   - FritzBox gateway URL, e. g. http://192.168.10.1:49000

## Example Playbook

Run the playbook in dry-run mode

    ansible-playbook playbooks/docker.yml --check

Run the playbook with vault password

    ansible-playbook playbooks/docker.yml --vault-password-file <path to password file>

## License

BSD

## Author Information

Bastard operator from hell
