#!/usr/bin/env -S just --justfile
# ^ A shebang isn't required, but allows a justfile to be executed
#   like a script, with `./justfile test`, for example.

set dotenv-filename := '.env'
set dotenv-load := false
# set dotenv-path := './'
set ignore-comments := false
set export
log := "warn"

#######################
##      Chooser     ###
#######################
default:
  @just --choose

#################################
###      Vagrant Commands     ###
#################################
up:
    @echo "Starting vagrant..."
    @vagrant up

connect:
    @echo "Connecting to Ansible Controller using vagrant..."
    @vagrant ssh controller

down:
    @echo "Stopping vagrant..."
    @vagrant destroy --force

#################################
##      Playbook Commands     ###
#################################
playbookdir := "./playbooks/"
playbookfile := playbookdir + "docker.yaml"

# Install the dependencies
install:
    @echo "Installing dependencies..."
    @ansible-galaxy install -r requirements.yaml
alias i := install

# Run the playbook command
play *PLAYBOOK :
    @echo "playbooking..."
    @ansible-playbook --become ./playbooks/{{ PLAYBOOK }} --verbose
alias p := play

######################################
##      Ansible Vault Commands     ###
######################################
vaultfile := "vault.yaml"
vaultpath := "./vars/" + vaultfile

# Encrypt the vault file
encrypt:
    @echo "encrypting..."
    @ansible-vault encrypt $vaultpath
alias e := encrypt

# View the vault file
view:
    @echo "viewing..."
    @ansible-vault view $vaultpath
alias v := view

# Edit the vault file
edit:
    @echo "editing..."
    @ansible-vault edit $vaultpath

# Decrypt the vault file
dencrypt:
    @echo "dencrypting..."
    @ansible-vault decrypt $vaultpath
alias de := dencrypt

############################
##      SSH Commands     ###
############################
home_dir := env('HOME', '~')
user := env('USER', 'ansible')

# Create the SSH key pair
ssh-key:
    @echo "Creating SSH key pair..."
    @ssh-keygen -t rsa -b 4096 -N "" -C "{{user}}@$(hostname)" -f {{home_dir}}/.ssh/ansible

# Add ansible public key to authorized keys
set-public-key:
    @echo "Setting public key..."
    @cat {{home_dir}}/.ssh/ansible.pub >> {{home_dir}}/.ssh/authorized_keys

# Remove the SSH key pair
clean:
    @echo "Cleaning..."
    @rm -rf {{home_dir}}/.ssh/ansible*