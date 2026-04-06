#!/bin/bash
set -e
# Fargate EKS cluster setup.
# Prerequisites: run `source ../eks-ec2/run.sh` first to install tools and set env vars.

# --- Create Fargate EKS cluster ---
eksctl create cluster \
  --name eks-fargate-pradyot \
  --region $REGION \
  --version 1.35 \
  --fargate

# --- Create namespace and Fargate profile ---
kubectl create ns dev
eksctl create fargateprofile \
  --cluster eks-fargate-pradyot \
  --region $REGION \
  --name dev-profile \
  --namespace dev

# --- Deploy workload ---
kubectl create deployment web-deploy --image=nginx:latest --replicas=3 -n dev

# --- Expose with NLB (required for Fargate — no NodePort/hostPort support) ---
kubectl apply -f fargate-load-balancer.yaml

# --- Force pod restart to pick up new config ---
kubectl rollout restart deployments/web-deploy -n dev

# --- Local access via port-forward (alternative to NLB) ---
# kubectl port-forward service/web-deploy-svc 8080:80 --address=0.0.0.0 -n dev

# --- Teardown ---
# eksctl delete cluster --name eks-fargate-pradyot --region $REGION
