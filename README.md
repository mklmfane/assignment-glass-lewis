# DevOps Engineer Technical Code Challenge

## 📋 Challenge Overview

In this challenge, you'll enhance and deploy a demo **online store application** on **Kubernetes** (preferably AKS), using a blend of **infrastructure as code**, **containerization**, and **CI/CD automation**.

---

## 📦 Submission Guidelines

1. **GitHub Repository**  
   Create a new GitHub repository for your solution, including all relevant files (Dockerfiles, Kubernetes manifests, CI/CD YAML files, etc.).  
   **Note**: Do NOT include any files from the AKS Demo repository.

2. **README File**  
   Document the following:
    - How to run the application locally (using Docker or Kubernetes)
    - How to configure and run the CI/CD pipeline
    - How to deploy the application to Kubernetes

---

## 🖥️ Local Environment Setup using Vagrant

To run the application locally or prepare your environment for Kubernetes deployment, start by provisioning a virtual machine using **HashiCorp Vagrant**.

### 🔧 Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Git

### 📁 VM Provisioning

Use the `Vagrantfile` provided [here](https://github.com/mklmfane/assignment-glass-lewis/blob/master/Vagrantfile).  
The VM installs the following automatically:

- Docker & Docker Compose
- Node.js
- Kubectl
- Minikube
- Terraform
- Helm

### ▶️ Start the VM

```bash
vagrant up
vagrant ssh

## ☸️ Kubernetes Cluster Setup with Terraform

Inside the VM, a local Kubernetes cluster can be provisioned using **Terraform**.

### ✅ Steps

```bash
cd ~/workspace/terraform-kubernetes-cluster
terraform init
terraform apply -auto-approve

Set KUBECONFIG and Verify Cluster
bash
Copy
Edit
export KUBECONFIG=${HOME}/kubeconfig-kind.yaml
kubectl get nodes --kubeconfig=${KUBECONFIG}

Running the Application Locally (Docker)
You can run the entire stack locally using Docker Compose.
Start Services
cd ~/workspace/src/docker-frontend-backend-db
docker-compose up --build
Check Running Containers
docker ps
CI/CD Pipeline with Jenkins
Jenkins is used to automate building, testing, and deploying the application.

📂 Jenkins Pipeline Files
Located in: pipelines/jenkins
Jenkinsfile
docker-build.groovy
k8s-deploy.groovy

Pipeline Stages
Checkout Code
Build Docker Images
Push Images to Container Registry
Deploy to Kubernetes using kubectl

Running the Jenkins Pipeline
Make sure Jenkins is installed and running (in Docker or on the VM), and then create a pipeline job pointing to your GitHub repository.

Deploying the Application to Kubernetes
The application includes:
 - Frontend – React App
 - Backend – Node.js Express API
 - MongoDB – NoSQL Database

Directory Structure
src/
├── backend/
│   └── Dockerfile
├── frontend/
│   └── Dockerfile
├── db/
│   └── Dockerfile
├── k8s/
│   ├── frontend-deployment.yaml
│   ├── backend-deployment.yaml
│   └── mongo-deployment.yaml

Apply Kubernetes Manifests
cd ~/workspace/src/docker-frontend-backend-db/k8s
kubectl apply -f mongo-deployment.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f frontend-deployment.yaml

Verify Resources
kubectl get pods
kubectl get svc

 Access the Application
bash
Copy
Edit
kubectl port-forward svc/frontend 3000:3000
Then visit http://localhost:3000 in your browser.

Local Docker Registry
To test pushing images to your local registry:
docker login localhost:5000 -u myuser -p mypassword
docker pull alpine
docker tag alpine localhost:5000/alpine
docker push localhost:5000/alpine

Registry Test (Unauthenticated & Authenticated)
bash
Copy
Edit
curl -u myuser:mypassword http://localhost:5000/v2/_catalog

# Authenticated using base64
curl -H "Authorization: Basic $(echo -n 'myuser:mypassword' | base64)" http://localhost:5000/v2/_catalog

Docker Registry: https://localhost:5000
Registry UI: http://localhost:30003

Test against CORS
curl -u myuser:mypassword -H "Origin: http://localhost:30003" -v http://localhost:5000/v2/_catalog

Summary
✅ VM is provisioned using Vagrant
✅ Kubernetes cluster created with Terraform
✅ Application runs locally using Docker Compose or Kubernetes
✅ CI/CD pipeline is managed by Jenkins
✅ Full deployment is described using Kubernetes Manifests
