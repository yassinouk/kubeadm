#!/bin/bash
#this script exits immediately if any command fails.
set -e
# This script is used to prepare the VMs for Kubernetes installation.
#NOTE: This script is meant to be run on each vm machine regardless of the role (controlplane, worker) 
#The vms should be running Ubuntu 22.04 LTS and configured with the appropriate network interfaces as shown in the documentation
#see the Prerequisite.md file for more information. 
# STEPS
#0 - Become root (saves typing sudo before every command) and disable swap.
sudo -i
swapoff -a
#1 - Update the apt package index and install packages needed to use the Kubernetes apt repository.
apt-get update
apt-get install -y apt-transport-https ca-certificates curl
#2 - Set up the required kernel modules and make them persistent.
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter
#3 - Set the required kernel parameters and make them persistent.
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system
#4 - Install the container (i used containerd in this demo) runtime, pin it's version.
apt-get install -y containerd
apt-mark hold containerd
#5 - Configure the container runtime to use systemd Cgroups.
mkdir -p /etc/containerd
containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/containerd/config.toml
#6 - Restart containerd.
systemctl restart containerd
#7 - Install the kubeadm, kubelet, and kubectl packages.
#7.1 - Get latest version of Kubernetes and store in a shell variable
KUBE_LATEST=$(curl -L -s https://dl.k8s.io/release/stable.txt | awk 'BEGIN { FS="." } { printf "%s.%s", $1, $2 }')
#7.2 - Download the Kubernetes public signing key.
mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
#7.3 - Add the Kubernetes apt repository.
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KUBE_LATEST}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
#7.4 - Update the apt package index, install kubelet, kubeadm and kubectl, and pin their version.
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
#8 - Configure crictl in case we need it to examine running containers.
crictl config \
    --set runtime-endpoint=unix:///run/containerd/containerd.sock \
    --set image-endpoint=unix:///run/containerd/containerd.sock
#9 - Prepare extra arguments for kubelet such that when it starts, it listens on the VM network address and not the NAT one. 
#This uses the predefined INTERNAL_IP environment variable.
# this line only gonna work if the VM has an ip address of the range 172.16.94.x so the network interface should be configured as stated in the Prerequisite.md file.
INTERNAL_IP=$(ip addr | awk '/inet / {split($2, a, "/"); if (a[1] ~ /^172\.16\.94/) print a[1]}')
cat <<EOF | sudo tee /etc/default/kubelet
KUBELET_EXTRA_ARGS='--node-ip ${INTERNAL_IP}'
EOF

# Output completion message in green
echo -e "\e[32mKubernetes node setup completed successfully.\e[0m"

# Provide instructions for the user to set up the control plane node.
echo -e "\e[32mYou can now initialize the control plane, use the cp_node_setup.sh script.\e[0m\n\e[33mNOTE: Only run the cp_node_setup.sh script on the control plane node.\e[0m"
# Exit with code 0 to indicate successful completion
exit 0