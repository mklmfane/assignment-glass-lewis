resource "null_resource" "kind_cluster" {
  provisioner "local-exec" {
    command = <<EOT
      set -eux

      # Delete any existing kind cluster
      sudo kind delete cluster --name kind || true

      # Create new kind cluster and write kubeconfig to a local file
      sudo kind create cluster --name kind \
        --config=./kind/kind-three-node-cluster.yaml \
        --kubeconfig=./kubeconfig-kind.yaml

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

      export KUBECONFIG=./kubeconfig-kind.yaml

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

      kubectl config get-contexts --kubeconfig=./kubeconfig-kind.yaml
      kubectl config current-context --kubeconfig=./kubeconfig-kind.yaml

      mkdir -p $HOME/.kube
      cp ./kubeconfig-kind.yaml $HOME/.kube/config
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

provider "kubernetes" {
  config_path = "${pathexpand("~/.kube/config")}"
}

provider "helm" {
  kubernetes {
    config_path = "${pathexpand("~/.kube/config")}"
  }
}