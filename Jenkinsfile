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

        stage('Lint Terraform') {
            steps {
                container('terraform') {
                sh 'terraform fmt -check'
                sh 'tfsec check'
                sh 'tflint'
                }
            }
        }

        stage('Lint Ansible') {
            steps {
                container('ansible') {
                sh 'ansible-lint'
                sh 'yamllint'
                }
            }
        }
    }
}
