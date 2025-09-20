#!/usr/bin/env bash
set -euo pipefail

ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
  amd64) KARCH=amd64 ;;
  arm64) KARCH=arm64 ;;
  *) echo "Desteklenmeyen mimari: $ARCH" >&2; exit 1 ;;
esac

KUBECTL_VERSION="$(curl -L -s https://dl.k8s.io/release/stable.txt)"
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${KARCH}/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f kubectl

if command -v kubectl >/dev/null 2>&1; then
  kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl >/dev/null || true
fi

echo "kubectl kurulumu tamam."
kubectl version --client

