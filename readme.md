# Kubernetes Practice

A hands-on K8s practice repo covering local Kind clusters and AWS EKS (EC2 + Fargate).

## Repository Structure

```
K8s-Practice/
├── kind/               # Local cluster via Kind
│   ├── config.yaml     # Kind cluster config (1 control-plane, 2 workers)
│   ├── ns.yaml         # Namespace: webapp
│   ├── pod.yaml        # Standalone Pod (learning only)
│   ├── replicaset.yaml # ReplicaSet (learning only — use Deployments in practice)
│   ├── webserver.yaml  # Deployment: web-appdeply
│   └── service.yaml    # ClusterIP Service → web-appdeply
├── eks-ec2/            # AWS EKS with EC2 nodes
│   ├── run.sh          # Install kubectl, AWS CLI, eksctl + set env vars
│   └── ec2-commands.sh # EC2 cluster create/apply/teardown reference
└── fargate/            # AWS EKS with Fargate
    ├── fargate-commands.sh       # Fargate cluster setup reference
    └── fargate-load-balancer.yaml # NLB Service for Fargate pods
```

## Quick Start

### Local (Kind)

```bash
# 1. Create cluster
kind create cluster --name mycluster --config=kind/config.yaml

# 2. Apply manifests in order
kubectl apply -f kind/ns.yaml
kubectl apply -f kind/webserver.yaml   # Deployment
kubectl apply -f kind/service.yaml # Service

# 3. Access locally
kubectl port-forward service/my-service -n webapp 8080:80 --address=0.0.0.0 &
```

### AWS EKS (EC2)

```bash
# 1. Install tools and set env vars (source, not execute)
source eks-ec2/run.sh

# 2. Review and run cluster commands
# See eks-ec2/ec2-commands.sh
```

### AWS EKS (Fargate)

```bash
# Prerequisites: tools installed via eks-ec2/run.sh
# See fargate/fargate-commands.sh
```

---

## Kubectl Reference

### Cluster Management (Kind)

```bash
kind create cluster --name mycluster --config=kind/config.yaml
kind delete cluster --name mycluster
```

### Apply & Inspect

```bash
kubectl apply -f <file.yaml>
kubectl diff -f <file.yaml>
kubectl get all -n webapp
kubectl get nodes
kubectl get ns
kubectl describe deployment web-appdeply -n webapp
```

### Rollout Management

```bash
# Watch rollout progress
kubectl rollout status deployments web-appdeply -n webapp

# Roll back to previous version
kubectl rollout undo deployments web-appdeply -n webapp

# Force restart (useful after ConfigMap changes)
kubectl rollout restart deployments/web-appdeply -n webapp

# Update image
kubectl set image deployment.apps/web-appdeply webapp=allenaira/netflix -n webapp
```

### Networking

```bash
# Port-forward a service locally
kubectl port-forward service/my-service -n webapp 8080:80 --address=0.0.0.0 &

# Expose a deployment as LoadBalancer
kubectl expose deployment.apps/web-appdeply -n webapp --port=80 --target-port=80 --type=LoadBalancer
```

### Environment Setup (AWS/EKS)

```bash
# Set env vars for current + future sessions
export REGION=us-east-1
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo 'export REGION=us-east-1' >> ~/.bashrc
echo 'export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)' >> ~/.bashrc

# Teardown
eksctl delete cluster --name eks-ec2-pradyot --region $REGION
```
