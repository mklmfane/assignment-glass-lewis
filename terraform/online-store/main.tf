provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}

resource "kubectl_manifest" "online_store" {
  for_each = fileset(path.module, "online-store-template.yaml")
  yaml_body = file("${path.module}/${each.value}")
}
