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
usermod -a -G docker jenkins

# Restart Docker service to apply group changes
systemctl restart docker

# Set Java 17 as default
update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java

# Setup SSH for Jenkins agent
mkdir -p /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh
touch /home/ubuntu/.ssh/authorized_keys
chmod 600 /home/ubuntu/.ssh/authorized_keys

# Add GitHub to known hosts
su - ubuntu -c "mkdir -p ~/.ssh"
su - ubuntu -c "ssh-keyscan -t rsa,dsa,ecdsa,ed25519 github.com >> ~/.ssh/known_hosts"
su - ubuntu -c "chmod 644 ~/.ssh/known_hosts"

# Create Jenkins work directory with proper permissions
mkdir -p /home/ubuntu/jenkins-workspace/remoting/jarCache
chown -R ubuntu:ubuntu /home/ubuntu/.ssh /home/ubuntu/jenkins-workspace

# Create agent startup script
cat > /home/ubuntu/jenkins-agent.sh << 'EOL'
#!/bin/bash
cd $HOME/jenkins-workspace
java -jar $HOME/remoting.jar -workDir $HOME/jenkins-workspace -jar-cache $HOME/jenkins-workspace/remoting/jarCache "$@"
EOL

chmod +x /home/ubuntu/jenkins-agent.sh
chown ubuntu:ubuntu /home/ubuntu/jenkins-agent.sh

# Install Trivy
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
apt update
apt install -y trivy

sleep 5; clear
echo "   =================================="
echo "** Your Build server is ready for use **"
echo "   =================================="
echo ""
echo "Jenkins agent configuration:"
echo "- Launch method: Launch agent via SSH"
echo "- Host: $(hostname -I | awk '{print $1}')"
echo "- Credentials: (your SSH credentials)"
echo "- Host Key Verification Strategy: Manually trusted key"
echo "- JavaPath: (leave empty)"
echo "- Prefix Start Agent Command: (leave empty)"
echo "- Suffix Start Agent Command: ~/jenkins-agent.sh"
echo ""