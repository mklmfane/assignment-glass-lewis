pipeline {
    agent {
        kubernetes {
            inheritFrom 'linting'
        }
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }


        stage('Lint Ansible') {
            steps {
                container('ansible') {
                sh 'ansible-lint || exit 0'
                }
            }
        }
        
        
        stage('Lint Terraform') {
            steps {
                container('terraform') {
                sh 'tflint || exit 0'
                }
            }
        }

        
    }
}
