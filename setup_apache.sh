#!/bin/bash
set -x
sudo apt update
sudo apt install -y apache2

sudo apt install -y nfs-common

sudo apt-get install geoip-bin -y

sudo mkdir /var/webserver_log
sudo mount 192.168.1.2:/var/webserver_monitor /var/webserver_log
