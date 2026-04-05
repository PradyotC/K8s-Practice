# Kubernetes Commands

### **Cluster Management (Kind)**
* **Create a cluster:** 
  ```bash
  kind create cluster --name mycluster --config=config.yaml
    ```

### **Applying & Modifying State**
* **Apply a configuration:**
    ```bash
    kubectl apply -f nginx.yaml
    ```
* **Update a container image:** Updates the `webapp` container in the `web-appdeply` deployment to a new image.
    ```bash
    kubectl set image deployment.apps/web-appdeply webapp=allenaira/netflix -n webapp
    ```
* **Check differences:** Compares the live state against your local manifest file.
    ```bash
    kubectl diff -f nginx.yaml
    ```

### **Viewing & Inspecting Resources**
* **List namespaces:**
    ```bash
    kubectl get ns
    ```
* **List cluster nodes:**
    ```bash
    kubectl get nodes
    ```
* **List all resources in a namespace:**
    ```bash
    kubectl get all -n webapp
    ```
* **Describe a deployment:** Provides detailed events, labels, and configurations for a specific deployment.
    ```bash
    kubectl describe deployment web-appdeply -n webapp
    ```

### **Rollout Management**
* **Check rollout status:** Watches the progress of your deployment update.
    ```bash
    kubectl rollout status deployments web-appdeply -n webapp
    ```
* **Rollback an update:** Reverts to the previous revision if an update fails.
    ```bash
    kubectl rollout undo deployments web-appdeply -n webapp
    ```
* **Restart a deployment:** Forces a rolling restart of all pods in a deployment, which is useful for pulling fresh images or applying updated ConfigMaps. 
    ```bash
    kubectl rollout restart deployments/mydeploy -n dev
    ```

### **Networking & Access**
* **Port Forwarding:** Forwards local traffic on port 8080 to port 80 on the target service (running in the background).
    ```bash
    kubectl port-forward service/my-service -n webapp 8080:80 --address=0.0.0.0 &
    ```
* **Expose a deployment:** Creates a LoadBalancer service to expose your deployment to external traffic. 
    ```bash
    kubectl expose deployment.apps/mydeploy -n dev --port=80 --target-port=80 --type=LoadBalancer
    ```

### **Environment Setup & Teardown (AWS/EKS)**
* **Configure bash variables:** Sets up and saves persistent environment variables for your AWS Region and Account ID.
    ```bash
    echo 'export REGION=us-east-1' >> ~/.bashrc
    echo 'export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)' >> ~/.bashrc
    source ~/.bashrc
    echo "Account: $ACCOUNT_ID | Region: $REGION"
    ```
* **Delete an EKS cluster:** Completely removes the specified EKS cluster and its associated AWS resources using `eksctl`.
    ```bash
    eksctl delete cluster --name=eks-ec2-pradyot --region=$REGION
    ```
