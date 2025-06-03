#!/bin/bash

# Quick fix for kubectl connection refused error

# Check if minikube is installed
if command -v minikube &> /dev/null; then
    echo "Starting minikube..."
    sudo minikube start --driver=none
    
    echo "Setting up kubeconfig..."
    mkdir -p $HOME/.kube
    sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown -R $(id -u):$(id -g) $HOME/.kube/
    
    echo "Setting KUBECONFIG environment variable..."
    export KUBECONFIG=$HOME/.kube/config
    echo 'export KUBECONFIG=$HOME/.kube/config' >> $HOME/.bashrc
else
    echo "Minikube not found. Installing minimal kubectl config..."
    
    # Create basic kubeconfig pointing to localhost
    mkdir -p $HOME/.kube
    cat > $HOME/.kube/config << EOF
apiVersion: v1
clusters:
- cluster:
    server: https://kubernetes.default.svc
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
EOF
    
    echo "You need to install a Kubernetes cluster. Run setup-minikube.sh to install minikube."
fi

# Test connection
echo "Testing kubectl connection..."
kubectl cluster-info