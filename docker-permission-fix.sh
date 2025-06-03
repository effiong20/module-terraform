#!/bin/bash

# This script fixes Docker permission issues for Jenkins

# Add the jenkins user to the docker group
sudo usermod -a -G docker jenkins
sudo usermod -a -G docker ubuntu
sudo usermod -a -G docker $(whoami)

# Create docker group if it doesn't exist
sudo groupadd -f docker

# Set permissions on Docker socket
sudo chmod 666 /var/run/docker.sock

# Restart Docker service
sudo systemctl restart docker

# Display current user's groups
echo "Current user groups:"
groups

echo "Docker permission fix complete. You may need to log out and back in for group changes to take effect."