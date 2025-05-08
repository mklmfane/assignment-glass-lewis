provider "kubernetes" {
  config_context_cluster = "kubernetes"
  config_path = "./VM_provisioning/_cluster_k8s_info/admin.conf"
}

provider "helm" {
  kubernetes {
  config_path = "./VM_provisioning/_cluster_k8s_info/admin.conf"
  }
}

# resource "helm_release" "calico" {
#   name       = "calico"
#   namespace   = "kube-system"
#   repository  = "https://docs.tigera.io/calico/charts"
#   chart       = "tigera-operator"
#   version    = "v3.28"

#   depends_on = [null_resource.wait_for_k8s]
# }

