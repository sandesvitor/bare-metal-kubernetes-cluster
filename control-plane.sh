#!/bin/bash

rm -rf /vagrant/join.sh

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

sudo kubeadm init --apiserver-advertise-address=192.168.55.101 --pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export TOKEN=$(sudo kubeadm token generate)
sudo kubeadm token create $TOKEN --ttl 1h --print-join-command >> /vagrant/join.sh
chmod +x /vagrant/join.sh


wget https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f calico.yaml

sudo sed '/port\=0$/d' /etc/kubernetes/manifests/kube-scheduler.yaml
sudo sed '/port\=0$/d' /etc/kubernetes/manifests/kube-controller-manager.yaml

sudo systemctl daemon-reload
sudo systemctl restart kubelet

# If you want to be able to schedule Pods on the control-plane node, 
# for example for a single-machine Kubernetes cluster for development
kubectl taint nodes --all node-role.kubernetes.io/master-


