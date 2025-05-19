#!/bin/bash

# Setup script for Inception project on a fresh Debian VM
# Run with sudo or as root

# Exit on error
set -e

echo "==== Setting up environment for Inception project ===="

# Update system
echo "Updating system packages..."
apt update && apt upgrade -y

# Install essential tools
echo "Installing essential tools..."
apt install -y curl wget git make apt-transport-https ca-certificates gnupg lsb-release

# Install Docker
echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group (replace username if needed)
echo "Adding your user to docker group..."
usermod -aG docker $USER
newgrp docker

# Create volume directories
echo "Creating directories for Docker volumes..."
mkdir -p /home/nmellal/data/mariadb
mkdir -p /home/nmellal/data/wordpress

# Set proper permissions
echo "Setting proper permissions..."
chmod -R 755 /home/nmellal/data

# Add domain to hosts file
echo "Adding nmellal.42.fr to hosts file..."
if ! grep -q "nmellal.42.fr" /etc/hosts; then
    echo "127.0.0.1    nmellal.42.fr" >> /etc/hosts
    echo "Added nmellal.42.fr to hosts file"
else
    echo "nmellal.42.fr already exists in hosts file"
fi

echo "==== Setup Complete ===="
echo "You may need to log out and back in for docker group changes to take effect."
echo "Run 'make' in the inception directory to build and start the containers."
echo "Access your site at https://nmellal.42.fr"