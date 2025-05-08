terraform {
  required_version = ">= 0.12.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}

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

resource "null_resource" "vagrant_cluster_and_k8s_wait" {
  provisioner "local-exec" {
    command     = <<EOT
      echo "🚀 Launching Vagrant cluster..."
      vagrant up
      echo "⏳ Waiting for Kubernetes API and nodes to become ready..."
      ${path.module}/wait-for-k8s-ready.sh
    EOT
    working_dir = "${path.module}"
  }

}

resource "null_resource" "nginx_ingress_static" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl --kubeconfig=./VM_provisioning/_cluster_k8s_info/admin.conf apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/baremetal/deploy.yaml
    EOT
  }

  depends_on = [null_resource.vagrant_cluster_and_k8s_wait]
}


# This resource is used to destroy the Vagrant cluster when the Terraform destroy command is executed.
resource "null_resource" "vagrant_cluster_destroy" {
  provisioner "local-exec" {
    when        = destroy
    command     = "vagrant destroy -f"
    working_dir = "${path.module}"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}