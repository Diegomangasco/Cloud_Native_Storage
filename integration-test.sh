#!/bin/bash
echo "Enabling kubevirt..."
minikube addons enable kubevirt
echo "Waiting for CRDs to deploy..."
kubectl wait --for condition=established crd/virtualmachines.kubevirt.io &> /dev/null
echo "kubevirt deployed!"

wget https://go.dev/dl/go1.16.linux-amd64.tar.gz &> /dev/null
tar -xf go1.16.linux-amd64.tar.gz &> /dev/null
sudo rm -rf /usr/local/go
sudo mv go /usr/local
sudo apt install -y make gcc

rm go1.16.linux-amd64.tar.gz
echo "PATH=\$PATH:/usr/local/go/bin" >> $HOME/.bashrc
PATH=$PATH:/usr/local/go/bin

echo "Installed go version: $(go version)"

BRANCH=${1:-"nfs-storage"}
echo "Using branch: $BRANCH"
wget https://github.com/matteorosani/CrownLabs/archive/refs/heads/$BRANCH.tar.gz &> /dev/null
tar -xf $BRANCH.tar.gz &> /dev/null
rm $BRANCH.tar.gz
mv CrownLabs-$BRANCH CrownLabs
echo -n "Installing CRDs and operators..."
( cd CrownLabs/operators && make install )
echo "Done!"
echo -n "Starting Instance operator..."
( cd CrownLabs/operators && make run-instance &> ~/instance-operator.log ) &
echo "Done!"
