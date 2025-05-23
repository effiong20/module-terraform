#!/bin/bash

# This script configures a Jenkins agent node
# Run as ubuntu user (not root)

# Create Jenkins work directory
mkdir -p ~/jenkins-workspace

# Create a simple script to launch the agent with correct parameters
cat > ~/jenkins-agent.sh << 'EOL'
#!/bin/bash
cd ~/jenkins-workspace
java -jar ~/remoting.jar -workDir ~/jenkins-workspace -jar-cache ~/jenkins-workspace/remoting/jarCache "$@"
EOL

# Make the script executable
chmod +x ~/jenkins-agent.sh

echo "Jenkins agent setup complete. Configure the agent in Jenkins with:"
echo "Launch method: Launch agent via SSH"
echo "Host: $(hostname -I | awk '{print $1}')"
echo "Credentials: (your SSH credentials)"
echo "Host Key Verification Strategy: Manually trusted key"
echo "JavaPath: (leave empty to use default)"
echo "Prefix Start Agent Command: (leave empty)"
echo "Suffix Start Agent Command: ~/jenkins-agent.sh"