#!/bin/bash
set -e

sudo apt update && sudo apt upgrade -y
sudo apt install docker.io unzip -y
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256) kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl kubectl.sha256

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/

# Install eksctl
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${PLATFORM}.tar.gz"
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check
tar -xzf "eksctl_${PLATFORM}.tar.gz" -C /tmp && rm "eksctl_${PLATFORM}.tar.gz"
sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl

# Set persistent environment variables
# NOTE: export here affects the current session; ~/.bashrc handles future sessions.
export REGION=us-east-1
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

grep -qxF 'export REGION=us-east-1' ~/.bashrc || echo 'export REGION=us-east-1' >> ~/.bashrc
grep -qF 'ACCOUNT_ID=' ~/.bashrc || echo 'export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)' >> ~/.bashrc

echo "Account: $ACCOUNT_ID | Region: $REGION"

# Verify installations
docker --version
kubectl version --client
aws --version
eksctl version
