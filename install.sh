#!/bin/bash

sudo swapoff -a
sed -i '/swap/d' /etc/fstab

echo "192.168.55.101    masternode" >> /etc/hosts
apt-get update
apt-get install -y docker.io apt-transport-https curl
systemctl start docker
systemctl enable docker

apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl