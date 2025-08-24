#!/bin/bash
#########
# Define variables
#########
SUDO_FILENAME=020_ansible-nopasswd
UBUNTU_CODENAME=jammy
# Possible values fot UBUNTU_CODENAME
# Debian 12 (Bookworm) --> jammy
# Debian 11 (Bullseye) --> focal
# Debian 10 (Buster)   --> bionic
#########
# Create ansible user
#########
# Create user with hine directory
sudo useradd -m ansible
# enable sudo for ansible user without password authentication
echo 'ansible ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/$SUDO_FILENAME > /dev/null
sudo chmod 440 /etc/sudoers.d/$SUDO_FILENAME
# Create .ssh subfolder
sudo mkdir /home/ansible/.ssh
# Copy public key of ansible user to enable ssh connection, set required permissions and owner:group
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQClaElngshv+kf03Ksb+YvyXQJLGS/zDdbfU7YLEiFsCXOb4W2GbstT2gEQo4WPmpyXCTqC2HYffhEssF9INPKIrohJ2kDTntszScukUH0fY4DvA2r52gcGUxuN43xmmvBny8DJ/P+5wa4fZOrhewneFNMCl/O05vZsw6C7uiCGsp9dAXv5MaLcgL3olTwOHLp9cYIRm+uMTxvQupUnSHgttCdpqE4SLRjVolXEIx+cFs206dARnM1oK2oJnCV7vXwmwZY/fLK/Eh1QRdEy0oqpnbNGf10U8KVegblmUmst5yRL1jm1AwOBPf1ehotmRHZYpnsiVSIKn2r9YEbl6rJJBeC/lpUUj5lfejCAmMwrigBtgEXo957OuizdbIkfgTaG39K5d9MzAiC96Nkz8pXFb4ZC9h817pvZBqMQGc8WQSOHq5RfSFE+l2o5PnOP9NzS+iXpLtyYPMLXXWazhGpoKwc7Fv28tSYOok4tGc2yftBCv8T2wbc1aU/i7Xp4clJ0ntL57bGNqABlHz5dOmamrL7XCt3OChZNH37JYDypfLHhqaUwcih1brl/eJX3Jvfs+g8i1g0z4F+1JzYc6H+Nrubzlwp0PmxuAfu/xaj2bzaEreaiaIYqoxByDoBDCzB5KOld3ma7XlNQ0QTs849GQWkSvQ8dnRXN0DrTZOSpBQ== ansible@raspberrypi' | sudo tee /home/ansible/.ssh/authorized_keys > /dev/null
sudo chown ansible:ansible /home/ansible/.ssh
sudo chmod 700 /home/ansible/.ssh
sudo chown ansible:ansible /home/ansible/.ssh/authorized_keys
sudo chmod 600 /home/ansible/.ssh/authorized_keys
#########
# Install ansible
#########
sudo rm -f /usr/share/keyrings/ansible-archive-keyring.gpg
wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367" | sudo gpg --dearmour -o /usr/share/keyrings/ansible-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/ansible-archive-keyring.gpg] http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/ansible.list
sudo apt update
sudo apt install ansible -y
#########
# Setup  ansible structure
#########
sudo mkdir -p /home/ansible/ansible/{inventory,playbooks,roles}
sudo chown -R ansible:ansible /home/ansible/ansible/