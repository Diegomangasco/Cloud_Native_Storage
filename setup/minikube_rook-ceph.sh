#!/bin/bash

# Install minikube 
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
sudo apt-get update
sudo apt-get install -y ca-certificates
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

# Install qemu-kvm, libvirt and nfs-common
sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils git kubectl nfs-common

# WARNING: a reboot is necessary here!

# Configure libvirt and kvm
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm
sudo chmod +x /var/run/libvirt/libvirt-sock
sudo chown root:libvirt /dev/kvm
sudo rmmod kvm_intel
sudo rmmod kvm
sudo modprobe -a kvm
sudo modprobe -a kvm_intel

# Comfortable Kubernetes settings
echo 'source <(kubectl completion bash)' >> $HOME/.bashrc
echo 'alias k=kubectl' >> $HOME/.bashrc
echo 'complete -F __start_kubectl k' >> $HOME/.bashrc
source $HOME/.bashrc

# Import rook-ceph packages
git clone --single-branch --branch v1.8.3 https://github.com/rook/rook.git
