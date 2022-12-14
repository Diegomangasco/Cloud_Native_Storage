#!/bin/bash
echo -n "Enabling kubevirt..."
minikube addons enable kubevirt &> /dev/null
kubectl wait --for condition=established crd/virtualmachines.kubevirt.io > /dev/null
echo "Done!"

echo -n "Installing go..."
{
    wget https://go.dev/dl/go1.16.linux-amd64.tar.gz
    tar -xf go1.16.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo mv go /usr/local
    rm go1.16.linux-amd64.tar.gz
    sudo apt install -y make gcc
} > /dev/null
echo "PATH=\$PATH:/usr/local/go/bin" >> $HOME/.bashrc
PATH=$PATH:/usr/local/go/bin
echo "Done!"

echo "Installed go version: $(go version)"

BRANCH=${1:-"nfs-storage"}
echo -n "Downloading CrownLabs using branch '$BRANCH'"
{
    wget https://github.com/matteorosani/CrownLabs/archive/refs/heads/$BRANCH.tar.gz
    tar -xf $BRANCH.tar.gz
    rm $BRANCH.tar.gz
    mv CrownLabs-$BRANCH CrownLabs
} &> /dev/null
echo "Done!"
echo -n "Installing CRDs and operators..."
( cd CrownLabs/operators && make install > /dev/null)
echo "Done!"
echo -n "Starting Instance operator..."
( cd CrownLabs/operators && make run-instance &> ~/instance-operator.log ) &
echo "Done!"
echo -n "Creating test instance..."
kubectl create -f https://raw.githubusercontent.com/Diegomangasco/Cloud_Native_Storage/main/instance.yaml > /dev/null
echo "Done!"