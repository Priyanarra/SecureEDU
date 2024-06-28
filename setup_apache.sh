#!/bin/bash
set -x
sudo apt update
sudo apt install -y apache2

# Install NFS server packages only on the observer node
if [ "$(hostname)" == "observer" ]; then
  sudo apt install -y nfs-kernel-server
  sudo mkdir -p /var/webserver_monitor
  sudo chown nobody:nogroup /var/webserver_monitor
  echo "/var/webserver_monitor 192.168.1.1(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports
  sudo exportfs -a
  sudo systemctl restart nfs-kernel-server
fi

# Install NFS client packages on the webserver node
if [ "$(hostname)" == "webserver" ]; then
  sudo apt install -y nfs-common
  sudo mkdir -p /var/webserver_log
  sudo mount 192.168.1.2:/var/webserver_monitor /var/webserver_log
fi
