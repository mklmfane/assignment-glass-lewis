terraform {
  required_version = ">= 0.12.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.29.0"
    }
  }
}

provider "kubernetes" {
  config_context_cluster = "kubernetes"
  config_path = "./VM_provisioning/_cluster_k8s_info/admin.conf"
}

provider "helm" {
  kubernetes {
    config_path = "./VM_provisioning/_cluster_k8s_info/admin.conf"
  }
}
