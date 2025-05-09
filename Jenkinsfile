pipeline {
  agent any

  environment {
    KUBECONFIG = '~/.kube/config'
  }

  stages {
    stage('Checkout Code') {
      steps {
        git url: 'https://github.com/mklmfane/assignment-glass-lewis.git'
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          echo "== Current Directory =="
          pwd

          echo "== Top-Level Contents =="
          ls -l

          echo "== Recursively searching for .tf files =="
          find . -type f -name "*.tf" || true
        '''
        sh 'terraform init -no-color'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -no-color -out=tfplan'
      }
    }

    stage('Terraform Apply') {
      steps {
        sh 'terraform apply -auto-approve tfplan -no-color'
      }
    }

    stage('Verify Kubernetes Nodes') {
      steps {
        sh '''
          echo "Using kubeconfig: $KUBECONFIG"
          if [ -f "$KUBECONFIG" ]; then
            kubectl get nodes
          else
            echo "Kubeconfig not found at $KUBECONFIG"
            exit 1
          fi
        '''
      }
    }
  }

  post {
    always {
      echo "Pipeline complete."
    }
    failure {
      echo "Cleaning up on failure..."
      dir('jenkins-vm') {
        sh 'terraform destroy -auto-approve -no-color'
      }
    }
  }
}