#!/bin/bash
# EKS EC2 cluster setup and teardown commands.
# Run run.sh first to install dependencies.
# Usage: reference only — do not execute this file directly.

# --- Create EC2-backed EKS cluster ---
eksctl create cluster \
  --name eks-ec2-pradyot \
  --region $REGION \
  --version 1.35 \
  --nodegroup-name standard-workers-p \
  --node-type t3.small \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 4 \
  --managed \
  --asg-access

# --- Apply manifests ---
kubectl apply -f ../kind/ns.yaml
kubectl apply -f ../kind/webserver.yaml
kubectl apply -f ../kind/service.yaml

# --- Rollout management ---
kubectl rollout status deployments web-appdeply -n webapp
kubectl rollout undo deployments web-appdeply -n webapp
kubectl set image deployment.apps/web-appdeply webapp=allenaira/netflix -n webapp

# --- Teardown ---
eksctl delete cluster --name eks-ec2-pradyot --region $REGION
