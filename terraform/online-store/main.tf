resource "null_resource" "apply_online_store" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/manifests/online-store-template.yaml"
  }
}
