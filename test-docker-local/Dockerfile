FROM ubuntu:22.04
RUN apt-get update && apt-get install --yes ansible

## Add ansible's public key for ssh
ADD ~/.ssh/ansible.pub /root/.ssh/authorized_keys
# USER ansible
# WORKDIR /home/ansible