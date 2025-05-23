#!/bin/bash

#---------------------------------------------#
# Author: Adam WezvaTechnologies
# Call/Whatsapp: +91-9739110917
#---------------------------------------------#

# Ensure script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or sudo privileges "
  exit 1
fi


# Install Java 8, 11, 17 & Docker
apt update
apt install -y openjdk-8-jdk openjdk-11-jdk openjdk-17-jdk docker.io maven openssh-server
usermod -a -G docker ubuntu

# Set Java 17 as default
update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java

# Setup SSH for Jenkins agent
mkdir -p /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh
touch /home/ubuntu/.ssh/authorized_keys
chmod 600 /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu:ubuntu /home/ubuntu/.ssh

# Install Trivy
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
apt update
apt install -y trivy

sleep 5; clear
echo "   =================================="
echo "** Your Build server is ready for use **"
echo "   =================================="