#!/usr/bin/env bash
set -euo pipefail

NS="default"
REL="my-redis"

NODE_IP=$(kubectl get node local-cluster-control-plane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
PORT=$(kubectl -n "$NS" get svc "$REL-master" -o jsonpath='{.spec.ports[0].nodePort}')
REDIS_PASS=$(kubectl -n "$NS" get secret "$REL" -o jsonpath='{.data.redis-password}' | base64 -d)

# redis-cli yoksa yükle
if ! command -v redis-cli >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y redis-tools
fi

echo "🔗 Redis’e bağlanılıyor: $NODE_IP:$PORT"
redis-cli -h "$NODE_IP" -p "$PORT" -a "$REDIS_PASS" PING
redis-cli -h "$NODE_IP" -p "$PORT" -a "$REDIS_PASS" SET hello world
redis-cli -h "$NODE_IP" -p "$PORT" -a "$REDIS_PASS" GET hello
echo "✅ Redis bağlantı testi OK"
