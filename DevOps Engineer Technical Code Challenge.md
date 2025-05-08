DevOps Engineer Technical Code Challenge
Challenge Overview:
In this challenge, you'll enhance and deploy a demo online store application on an
Kubernetes (preferably AKS), using a blend of infrastructure as code, containerization,
and CI/CD automation.

Submission Guidelines:
1. GitHub Repository: Create a new GitHub repository for your solution, including
all relevant files (Dockerfiles, Kubernetes manifests, CI/CD YAML files, etc.).
Note: Do NOT include any files from the AKS Demo repository

2. README: Write a README that explains:
oHow to run the application locally (using Docker or Kubernetes).
oHow to configure and run the CI/CD pipeline.
oHow to deploy the application to Kubernetes

Environment setup
Use the following repository for Online store demohttps://github.com/Azure-
Samples/aks-store-demo and the following manifestaks-store-quickstart.yamlas
starting point.

Challenge Steps:
1. Complete the Kubernetes manifest with Ingress controller
· Task: Add Ingress controller definition to the Kubernetes manifest
2. Create Kubernetes cluster by Terraform
· Task: Create the cluster using Terraform
3. Create CI/CD for the project
· Task: Implement a CI/CD pipeline usingyaml , preferably Azure DevOps:
oCI
    § Building the Docker images for the frontend and backend.
    § Testing the application before deploying.
    § Pushing the Docker images toAzure Container Registry (ACR) or
    another container registry.
    oCD
    § Deploying the updated images to an AKS cluster.
4. Bonus steps
· Task: Create Helm chart, include resource limits and improve inter-service
security.
oCreate aHelm chart to manage the application's deployment.
oIncluderesource requests andlimits for containers.
oimplementnetwork policies to limit inter-service communication within
the Kubernetes cluster