pipeline {
  agent any

  environment {
    // Use default kubeconfig path that Terraform copies to
    KUBECONFIG = "${HOME}/.kube/config"
  }

  stages {
    stage('Checkout Code') {
      steps {
        git url: 'https://github.com/mklmfane/assignment-glass-lewis.git'
      }
    }

    stage('Terraform Init to list files') {
      steps {
        sh '''
          echo "== Current Directory =="
          pwd

          echo "== Top-Level Contents =="
          ls -l

          echo "== Searching for .tf files =="
          find . -type f -name "*.tf" || true
        '''
        sh 'terraform init -no-color'
      }
    }

    stage('Terraform Plan for Kubernetes clsuter') {
      steps {
        sh 'terraform plan -no-color -out=tfplan'
      }
    }

    stage('Create kubernetes Cluster using Terraform') {
      steps {
        sh 'terraform apply -auto-approve tfplan -no-color'
      }
    }

    stage('Verify Kubernetes Nodes') {
      steps {
        sh '''
          echo "Using kubeconfig at: $KUBECONFIG"
          
          if [ ! -f "$KUBECONFIG" ]; then
            echo "❌ Kubeconfig not found at $KUBECONFIG"
            exit 1
          fi

          chmod 600 "$KUBECONFIG"
          echo "✅ kubeconfig permissions set"

          echo "✅ Listing nodes:"
          kubectl get nodes
        '''
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