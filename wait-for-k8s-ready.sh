#!/bin/bash

echo "📡 Waiting for Kubernetes API to become reachable..."
for i in {1..60}; do
  if curl --silent --insecure --max-time 2 https://192.168.56.2:6443/version >/dev/null; then
    echo "✅ API is reachable. Checking node readiness..."
    for j in {1..60}; do
      kubectl --kubeconfig=./VM_provisioning/_cluster_k8s_info/admin.conf get nodes > /tmp/nodes_status 2>/dev/null
      if [ $? -ne 0 ]; then
        echo "⚠️ kubectl failed (API unstable?). Retrying..."
        sleep 5
        continue
      fi

      READY=$(grep -c " Ready" /tmp/nodes_status)

      echo "🔄 $READY of 3 nodes are Ready..."

      if [ "$READY" -eq 3 ]; then
        echo "🎉 All 3 Kubernetes nodes are Ready."
        exit 0
      fi

      echo "⏳ Waiting for all 3 nodes..."; sleep 5
    done
  else
    echo "🌐 API not reachable yet..."; sleep 5
  fi
done

echo "❌ Timeout: Kubernetes API or all 3 nodes not ready"
exit 1
