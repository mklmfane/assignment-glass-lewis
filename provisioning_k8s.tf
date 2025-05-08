provider "kubernetes" {
  config_context_cluster = "kubernetes"
  config_path = "./VM_provisioning/_cluster_k8s_info/admin.conf"
}

provider "helm" {
  kubernetes {
  config_path = "./VM_provisioning/_cluster_k8s_info/admin.conf"
  }
}
