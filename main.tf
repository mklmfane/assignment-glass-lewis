# Launch the Vagrant-based Kubernetes cluster
resource "null_resource" "vagrant_cluster" {
  provisioner "local-exec" {
    command = <<EOT
      echo "🚀 Launching Vagrant cluster..."
      vagrant up
      echo "⏳ Waiting for Kubernetes API and nodes to become ready..."
      ${path.module}/wait-for-k8s-ready.sh
    EOT
    working_dir = "${path.module}"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}


# Wait for the Kubernetes API to become reachable and all nodes to be Ready
resource "null_resource" "wait_for_k8s" {
  provisioner "local-exec" {
    command     = "${path.module}/wait-for-k8s-ready.sh"
    working_dir = "${path.module}"
  }

  depends_on = [null_resource.vagrant_cluster]
}



