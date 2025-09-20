#!/usr/bin/env bash
set -euo pipefail

NS="default"
REL="my-postgres"

# Control-plane node’un InternalIP’si
NODE_IP=$(kubectl get node local-cluster-control-plane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')

# NodePort’u al
PORT=$(kubectl -n "$NS" get svc "$REL-postgresql" -o jsonpath='{.spec.ports[0].nodePort}')

# Parolayı secret’tan çek
PG_PASS=$(kubectl -n "$NS" get secret "$REL-postgresql" -o jsonpath='{.data.postgres-password}' | base64 -d)

# psql yoksa yükle
if ! command -v psql >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y postgresql-client
fi

echo "🔗 PostgreSQL’e bağlanılıyor: $NODE_IP:$PORT (user=postgres, db=postgres)"
PGPASSWORD="$PG_PASS" psql -h "$NODE_IP" -p "$PORT" -U postgres -d postgres -c "SELECT version();"
echo "✅ PostgreSQL bağlantı testi OK"
