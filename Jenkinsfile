pipeline {
  agent any

  environment {
    KUBECONFIG = "${HOME}/.kube/config"
  }

  stages {
    stage('Checkout Code') {
      steps {
        git url: 'https://github.com/mklmfane/assignment-glass-lewis.git'
      }
    }

    stage('Terraform Init for Kubernetes Cluster') {
      steps {
        sh '''
          echo "== Current Directory =="
          pwd

          echo "== Top-Level Contents =="
          ls -l

          echo "== Searching for .tf files =="
          find . -type f -name "*.tf" || true

          terraform init -no-color
        '''
      }
    }

    stage('Terraform Plan for Kubernetes Cluster') {
      steps {
        sh 'terraform plan -no-color -out=tfplan'
      }
    }

    stage('Create Kubernetes Cluster using Terraform') {
      steps {
        sh 'terraform apply -auto-approve tfplan -no-color'
      }
    }

    stage('Wait for Cluster Readiness (~5 minutes max)') {
      steps {
        sh '''
          echo "Waiting for Kubernetes cluster to be ready..."

          for i in {1..30}; do
            if kubectl get nodes >/dev/null 2>&1; then
              echo "✅ Kubernetes cluster is ready!"
              kubectl get nodes
              break
            fi
            echo "Cluster not ready yet... retrying in 10 seconds"
            sleep 10
          done
        '''
      }
    }

    stage('Deploy Ingress NGINX Controller (Terraform)') {
      steps {
        dir('terraform/ingress') {
          sh '''
            echo "Deploying ingress-nginx via Terraform..."
            terraform init -no-color
            terraform apply -auto-approve -no-color
          '''
        }
      }
    }

    stage('Verify Ingress NGINX Deployment') {
      steps {
        sh 'kubectl get all -n ingress-nginx'
      }
    }
  }

  post {
    always {
      echo "✅ Pipeline complete."
    }
    failure {
      echo "❌ Pipeline failed. Cleaning up..."
      sh 'terraform destroy -auto-approve -no-color || true'
    }
  }
}