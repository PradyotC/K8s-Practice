#!/bin/bash

kubectl apply -f ../ns.yaml
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
kubectl apply -f webserver.yaml

kubectl get pods -n webapp

kubectl exec pod/web-appdeply-<your-pod-id> -c webapp -n webapp -- env | grep -E "LOG_LEVEL|API_KEY"

kubectl logs pod/web-appdeply-<your-pod-id> -c sidecar-monitor -n webapp