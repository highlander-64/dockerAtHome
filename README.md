# Prepare Docker machine and manage it via ansible

## Ubuntu 24.04 LTS on Intel system

### Preparation

- Download the latest Ubuntu image from [Ubuntu Homepage](https://ubuntu.com/download/server)
- Download Rufus for creating a bootable USB flash drive from [Rufus Homepage](https://rufus.ie/en/)
- Create a bootable USB flash drive based on Ubuntu image  
![Rufus](./pictures/Rufus.png)
- Copy the files to the root directory:
  - autoinstall.yaml
  - user-data
  - meta-data
- Copy the modified grub configuration:
  - /boot/grub/grub.cfg
- Boot your new docker machine from USB and wait until the installation is done

If you want to modify the installation, please keep in mind, *autoinstall.yaml* and *user-data* need to be converted in UNIX text format, e. g. using dos2unix

## Use Raspberry PI as ansible master

Create a boot image based on the latest version for your Raspberry PI with [Raspberry Pi Imager](https://www.raspberrypi.com/software/).

Log in to the Raspberry Pi with your user and run the script *create_ansible
_user.sh*.

Copy your ansible private key to /home/ansible/.ssh and set permissions.

```bash
chmod 600 /home/ansible/<YOUR_PRIVATE_KEY>
```

Create a ansible configuration file or use your repository to setup your ansible installation.

You can use ansible galaxy to create role directory structure:

```bash
cd ~/ansbile/roles
ansible-galaxy init <YOUR_ROLENAME>
```

### Testing ansible

The simplest way to test the ansible connection is the buildin ping function.

```bash
ansible all -m ping
```

You should get an answer from all systems defined your inventory file.

## Collection of hints and tipps to get the environment running

### ssh connection after reboot take several minutes

option 1:  
Edit /etc/ssh/sshd_config and set GSSAPIAuthentication=no

option 2:  
Edit ~/.ssh/config and add  

```bash
Host *
  GSSAPIAuthentication no
```

## Git

### Using dedicated private key for github

Copy private key into ~/.ssh/

Edit ~/.ssh/config and add

```bash
Host github.com
  User git
  Hostname github.com
  IdentityFile ~/.ssh/<your_private_key_file>
```

Don't forget to set the required permissions

```bash
chmod 600 ~/.ssh/<your_private_key_file>
```
