#!/bin/bash
#this script exits immediately if any command fails.
set -e
# Set colors for prompts
GREEN="\e[32m"  # ANSI escape code for green color
ORANGE="\e[38;5;208m"  # ANSI escape code for orange color
RED="\e[31m"  # ANSI escape code for red color
NC="\e[0m"  # ANSI escape code to reset color

# Switch to root user
sudo -i

# This script is used to configure the controlplane node.
#NOTE: This script is meant to be run on the controlplane node only.

# STEPS

POD_CIDR=10.244.0.0/16
SERVICE_CIDR=10.96.0.0/16

#Here we are using arguments to kubeadm to ensure that it uses the networks and IP address we want rather than choosing defaults which may be incorrect.
#We also use the INTERNAL_IP environment variable to ensure that the controlplane listens on the VM network address and not the NAT one.

# Check if INTERNAL_IP is empty
if [ -z "$INTERNAL_IP" ]; then
    # Reassign INTERNAL_IP if it's empty
    INTERNAL_IP=$(ip addr | awk '/inet / {split($2, a, "/"); if (a[1] ~ /^172\.16\.94/) print a[1]}')
    echo "Internal IP address obtained: $INTERNAL_IP"
else
    echo "INTERNAL_IP variable is not empty. Skipping obtaining internal IP address."
fi

if ! kubeadm init --pod-network-cidr $POD_CIDR --service-cidr $SERVICE_CIDR --apiserver-advertise-address $INTERNAL_IP; then
    echo -e "${RED}Error: Failed to initialize the control plane.${NC}"
    exit 1
fi

# Prompt the user to copy the kubeadm join command
echo -e "${ORANGE}Please copy the kubeadm join command that is printed at the end of this script and run it on the worker nodes.${NC}"
echo -e "${GREEN}Your Kubernetes control-plane has initialized successfully!${NC}"
