#!/bin/bash

echo "Initializing test environment"
{
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm
sudo chmod +x /var/run/libvirt/libvirt-sock
sudo chown root:libvirt /dev/kvm
sudo rmmod kvm_intel
sudo rmmod kvm
sudo modprobe -a kvm
sudo modprobe -a kvm_intel
} &> /dev/null

minikube start --disk-size=8g --extra-disks=1 --driver kvm2 -n 2 --memory 4096 --cpus 2

echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc
source ~/.bashrc

BASE_URL="https://raw.githubusercontent.com/rook/rook/v1.10.0/deploy/examples/"
for FILE in "crds.yaml" "common.yaml" "operator.yaml" "cluster-test.yaml" "filesystem-test.yaml" "nfs-test.yaml" "csi/nfs/rbac.yaml" "csi/nfs/storageclass.yaml"
do
    kubectl create -f $BASE_URL$FILE
done
kubectl --namespace rook-ceph patch configmap rook-ceph-operator-config --type merge --patch '{"data":{"ROOK_CSI_ENABLE_NFS": "true"}}'
