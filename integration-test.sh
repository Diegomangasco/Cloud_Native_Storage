#!/bin/bash
echo "Enabling kubevirt..."
minikube addons enable kubevirt
echo "Waiting for CRDs to deploy..."
kubectl wait --for condition=established crd/virtualmachines.kubevirt.io &> /dev/null
echo "kubevirt deployed!"

wget https://go.dev/dl/go1.16.linux-amd64.tar.gz
tar -xf go1.16.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo mv go /usr/local
sudo apt install -y make gcc

rm go1.16.linux-amd64.tar.gz
echo "PATH=\$PATH:/usr/local/go/bin" >> $HOME/.bashrc
source $HOME/.bashrc

echo "Installed go version: $(go version)"
echo "Launching instance operator..."
wget https://github.com/netgroup-polito/CrownLabs/archive/refs/heads/master.tar.gz
tar -xf master.tar.gz
cd CrownLabs-master/operators && make install
cd CrownLabs-master/operators && make run-instance &> ~/instance-operator.log &
echo "Launched!
