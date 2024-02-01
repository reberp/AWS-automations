#!/bin/bash

apt update

# 
apt install docker.io -y
systemctl enable docker

# kube keying to download
mkdir -p /etc/apt/keyrings
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list
apt update

# get kubernetes tools
apt install -y kubeadm kubelet kubectl 

# set their install versions
apt-mark hold kubeadm kubelet kubectl

# k8s doesn't do well with swap. Turn off now and after restart
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# traffic forwarding related stuff
echo "overlay" >> /etc/modules-load.d/containerd.conf
echo "br_netfilter" >> /etc/modules-load.d/containerd.conf
modprobe overlay
modprobe br_netfilter

cat << EOF > /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# load changes
sysctl --system

# req'd containerd changes that fixed permission issue? 
mkdir -p /etc/containerd
sh -c "containerd config default > /etc/containerd/config.toml"
sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd

# CNI
mkdir -p /opt/cni/bin
curl -O -L https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz
tar -C /opt/cni/bin -xzf cni-plugins-linux-amd64-v1.2.0.tgz
rm cni-plugins-linux-amd64-v1.2.0.tgz