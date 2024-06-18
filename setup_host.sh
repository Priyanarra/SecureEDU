#!/bin/bash

apt update
apt install -y nfs-common
mkdir -p /var/nfs/keys

while [ ! -f /var/nfs/keys/id_rsa ]; do
  mount 192.168.1.1:/var/nfs/keys /var/nfs/keys
  sleep 10
done

cp /var/nfs/keys/id_rsa* /users/lngo/.ssh/
chown lngo: /users/hn9672/.ssh/id_rsa*
runuser -u hn9672 -- cat /users/hn9672/.ssh/id_rsa.pub >> /users/hn9672/.ssh/authorized_keys
