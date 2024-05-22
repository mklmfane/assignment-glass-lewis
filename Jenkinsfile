pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Lint Terraform') {
            steps {
                sh 'terraform fmt -check'
                sh 'tfsec check'
                sh 'tflint'
            }
        }

        stage('Lint Ansible') {
            steps {
                sh 'ansible-lint'
                sh 'yamllint'
            }
        }
    }
}
