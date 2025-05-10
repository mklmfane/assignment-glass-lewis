provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}

resource "kubernetes_manifest" "online_store" {
  manifest = yamldecode(file("${path.module}/online-store.yaml"))
}