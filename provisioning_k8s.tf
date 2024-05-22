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
resource "kubernetes_namespace" "devops-tools" {
  metadata {
    name      = "devops-tools"
  }
}

resource "kubernetes_persistent_volume_claim" "pvc-jenkins" {
  metadata {
    name = "pvc-jenkins"
    namespace = "devops-tools"
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    volume_name = "${kubernetes_persistent_volume.pv-jenkins.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume" "pv-jenkins" {
  metadata {
    name = "pv-jenkins"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      host_path {
        path = "/mnt/k8s-data"
      }
    }
  }
}




resource "helm_release" "jenkins" {
  name       = "jenkins"
  namespace   = "devops-tools"
  repository  = "https://charts.jenkins.io"
  chart       = "jenkins"
  version    = "5.1.20"
  values = [
    "${file("k8s_apps/jenkins-value.yml")}"
  ]
}