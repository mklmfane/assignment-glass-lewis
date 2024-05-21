provider "kubernetes" {
  config_context_cluster = "kubernetes"
  config_path = "./VM_provisioning/_cluster_k8s_info/admin.conf"
}

provider "helm" {
  kubernetes {
  config_path = "./VM_provisioning/_cluster_k8s_info/admin.conf"
  }
}

resource "helm_release" "calico" {
  name       = "calico"
  namespace   = "kube-system"
  repository  = "https://docs.tigera.io/calico/charts"
  chart       = "tigera-operator"
  version    = "v3.28"
}

resource "kubernetes_namespace" "kiratech-test" {
  metadata {
    name      = "kiratech-test"
  }
}

resource "kubernetes_job" "kube-bench" {
  metadata {
    name = "kube-bench"
  }
  spec {
    template {
      metadata {
        labels = {
          app = "kube-bench"
        }
      }
      spec {
        container {
          name = "kube-bench"
          image = "aquasec/kube-bench:latest"
          command = ["kube-bench", "run", "--json", "--outputfile", "/tmp/kube-bench-results.json"]
          volume_mount {
            name = "kube-bench-results"
            mount_path = "/tmp"
          }
        }
        volume {
          name = "kube-bench-results"
          host_path {
            path = "/tmp/kube-bench-results"
          }
        }
      }
    }
  }
}