terraform {
  required_version = ">= 0.12.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.29.0"
    }
    
    kind = {
      source  = "tehcyx/kind"
      version = "0.2.1"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}
