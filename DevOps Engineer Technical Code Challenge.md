DevOps Engineer Technical Code Challenge
### Challenge Overview:
In this challenge, you'll enhance and deploy a demo online store application on Kubernetes (preferably AKS), using a blend of infrastructure as code, containerization, and CI/CD automation.
### Challenge Overview:
In this challenge, you'll enhance and deploy a demo online store application on Kubernetes (preferably AKS), using a blend of infrastructure as code, containerization, and CI/CD automation.

### Submission Guidelines:
1. **GitHub Repository**: Create a new GitHub repository for your solution, including all relevant files (Dockerfiles, Kubernetes manifests, CI/CD YAML files, etc.).  
    **Note**: Do NOT include any files from the AKS Demo repository.

2. **README**: Write a README that explains:
    - How to run the application locally (using Docker or Kubernetes).
    - How to configure and run the CI/CD pipeline.
    - How to deploy the application to Kubernetes.

---

### Environment Setup:
Use the following repository for the online store demo:  
[https://github.com/Azure-Samples/aks-store-demo](https://github.com/Azure-Samples/aks-store-demo)  
and the `manifestaks-store-quickstart.yaml` file as a starting point.

---

### Challenge Steps:
1. **Complete the Kubernetes Manifest with Ingress Controller**  
    - **Task**: Add an Ingress controller definition to the Kubernetes manifest.

2. **Create Kubernetes Cluster Using Terraform**  
    - **Task**: Create the cluster using Terraform.

3. **Create CI/CD for the Project**  
    - **Task**: Implement a CI/CD pipeline using YAML, preferably Azure DevOps:  
      - **CI**:  
         - Build the Docker images for the frontend and backend.  
         - Test the application before deploying.  
         - Push the Docker images to Azure Container Registry (ACR) or another container registry.  
      - **CD**:  
         - Deploy the updated images to an AKS cluster.

---

### Bonus Steps:
- **Task**: Create a Helm chart, include resource limits, and improve inter-service security.  
  - Create a Helm chart to manage the application's deployment.  
  - Include resource requests and limits for containers.  
  - Implement network policies to limit inter-service communication within the Kubernetes cluster.
### Submission Guidelines:
1. **GitHub Repository**: Create a new GitHub repository for your solution, including all relevant files (Dockerfiles, Kubernetes manifests, CI/CD YAML files, etc.).  
    **Note**: Do NOT include any files from the AKS Demo repository.

2. **README**: Write a README that explains:
    - How to run the application locally (using Docker or Kubernetes).
    - How to configure and run the CI/CD pipeline.
    - How to deploy the application to Kubernetes.

---

### Environment Setup:
Use the following repository for the online store demo:  
[https://github.com/Azure-Samples/aks-store-demo](https://github.com/Azure-Samples/aks-store-demo)  
and the `manifestaks-store-quickstart.yaml` file as a starting point.

---

### Challenge Steps:
1. **Complete the Kubernetes Manifest with Ingress Controller**  
    - **Task**: Add an Ingress controller definition to the Kubernetes manifest.

2. **Create Kubernetes Cluster Using Terraform**  
    - **Task**: Create the cluster using Terraform.

3. **Create CI/CD for the Project**  
    - **Task**: Implement a CI/CD pipeline using YAML, preferably Azure DevOps:  
      - **CI**:  
         - Build the Docker images for the frontend and backend.  
         - Test the application before deploying.  
         - Push the Docker images to Azure Container Registry (ACR) or another container registry.  
      - **CD**:  
         - Deploy the updated images to an AKS cluster.

---

### Bonus Steps:
- **Task**: Create a Helm chart, include resource limits, and improve inter-service security.  
  - Create a Helm chart to manage the application's deployment.  
  - Include resource requests and limits for containers.  
  - Implement network policies to limit inter-service communication within the Kubernetes cluster.