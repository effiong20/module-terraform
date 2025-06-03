#!/bin/bash

# This script sets up kubectl configuration

# Check if kubeconfig exists
if [ ! -f "$HOME/.kube/config" ]; then
    echo "No kubeconfig found. Creating directory..."
    mkdir -p $HOME/.kube
fi

# Set up kubeconfig
echo "Setting up kubeconfig..."
cat > $HOME/.kube/config << EOF
apiVersion: v1
clusters:
- cluster:
    server: https://your-kubernetes-api-server:6443
    certificate-authority-data: YOUR_CA_DATA_HERE
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: YOUR_CERT_DATA_HERE
    client-key-data: YOUR_KEY_DATA_HERE
EOF

echo "Kubeconfig created. Please replace the placeholder values with your actual cluster information."
echo "To test the connection, run: kubectl cluster-info"