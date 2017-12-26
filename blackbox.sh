#!/bin/bash

# Make blackbox_exporter user
sudo adduser --no-create-home --disabled-login --shell /bin/false --gecos "Blackbox Exporter User" blackbox_exporter

# Make directories and dummy files necessary for blackbox exporter
sudo mkdir /etc/blackbox
sudo touch /etc/blackbox/blackbox.yml
sudo chown -R blackbox_exporter:blackbox_exporter /etc/blackbox

# Download blackbox_exporter and copy utilities to where they should be in the filesystem
wget https://github.com/prometheus/blackbox_exporter/releases/download/v0.11.0/blackbox_exporter-0.11.0.linux-amd64.tar.gz
tar xvzf blackbox_exporter-0.11.0.linux-amd64.tar.gz

sudo cp blackbox_exporter-0.11.0.linux-amd64/blackbox_exporter /usr/local/bin/
sudo chown blackbox_exporter:blackbox_exporter /usr/local/bin/blackbox_exporter

# Populate configuration files
cat ./blackbox/blackbox.yml | sudo tee /etc/blackbox/blackbox.yml
cat ./blackbox/blackbox_exporter.service | sudo tee /etc/systemd/system/blackbox_exporter.service

# systemd
sudo systemctl daemon-reload
sudo systemctl enable blackbox_exporter
sudo systemctl start blackbox_exporter

# Installation cleanup
sudo rm blackbox_exporter-0.11.0.linux-amd64.tar.gz
sudo rm -rf blackbox_exporter-0.11.0.linux-amd64
