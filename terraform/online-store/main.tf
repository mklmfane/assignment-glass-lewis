variable "dockerconfigjson_b64" {}

resource "local_file" "online_store_yaml" {
  filename = "${path.module}/manifests/online-store.yaml"
  content  = templatefile("${path.module}/manifests/online-store-template.yaml", {
    dockerconfigjson_b64 = var.dockerconfigjson_b64
  })
}

resource "null_resource" "apply_online_store" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.online_store_yaml.filename}"
  }
  depends_on = [local_file.online_store_yaml]
}
