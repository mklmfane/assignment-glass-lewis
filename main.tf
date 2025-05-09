resource "null_resource" "kind_cluster" {
  provisioner "local-exec" {
    command = <<EOT
      set -eux

      kind delete cluster --name kind || true

      kind create cluster --name kind \
        --config=${path.module}/kind/kind-three-node-cluster.yaml \
        --kubeconfig=${path.module}/kubeconfig-kind.yaml

      echo "Cluster created at $(date)"
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "wait_for_cluster_ready" {
  depends_on = [null_resource.kind_cluster]

  provisioner "local-exec" {
    command = <<EOT
      echo "✅ Waiting for Kubernetes API to become fully responsive..."

      export KUBECONFIG=${path.module}/kubeconfig-kind.yaml

      for i in $(seq 1 60); do
        if kubectl get ns kube-system >/dev/null 2>&1; then
          echo "✅ kube-system is available"
          break
        fi
        echo "⏳ Waiting for kube-system... ($i/60)"
        sleep 5
      done

      echo "⏳ Sleeping an additional 60 seconds for full API warmup..."
      sleep 60

      # Final check
      kubectl cluster-info || {
        echo "❌ Kubernetes API not responsive"
        exit 1
      }
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "verify_kubeconfig" {
  depends_on = [null_resource.wait_for_cluster_ready]

  provisioner "local-exec" {
    command = <<EOT
      echo "✅ Verifying kubeconfig without exposing credentials..."
      kubectl config get-contexts --kubeconfig=${path.module}/kubeconfig-kind.yaml
      kubectl config current-context --kubeconfig=${path.module}/kubeconfig-kind.yaml
      mkdir -p $HOME/.kube
      cp ${path.module}/kubeconfig-kind.yaml $HOME/.kube/config
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

# This provider is used to interact with the Kubernetes cluster
# created by the kind provider. It uses the kubeconfig file generated
# by the kind provider to connect to the cluster.

provider "kubectl" {
  config_path = "$HOME/.kube/config"
}