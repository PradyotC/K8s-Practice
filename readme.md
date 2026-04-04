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

### **Networking & Access**
* **Port Forwarding:** Forwards local traffic on port 8080 to port 80 on the target service (running in the background).
    ```bash
    kubectl port-forward service/my-service -n webapp 8080:80 --address=0.0.0.0 &
    ```
