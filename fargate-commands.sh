wget -qO- "https://raw.githubusercontent.com/PradyotC/K8s-Practice/refs/heads/main/run.sh" | bash

eksctl create cluster \
    --name eks-fargate-pradyot \
    --region $REGION \
    --version 1.35 \
    --fargate

kubectl create ns dev

eksctl create fargateprofile --cluster eks-fargate-pradyot --region=$REGION --name dev-profile --namespace dev

kubectl create deployment web-deploy --image=nginx:latest --replicas=3 -n dev

kubectl apply -f fargate-load-balancer.yaml

kubectl rollout restart deployments/web-deploy -n dev

kubectl port-forward service/web-deploy-svc 8080:80 --address=0.0.0.0 -n dev

eksctl delete cluster --name eks-fargate-pradyot --region $REGION
