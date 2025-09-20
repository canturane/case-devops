#!/usr/bin/env bash
set -euo pipefail

curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

if command -v helm >/dev/null 2>&1; then
  helm completion bash | sudo tee /etc/bash_completion.d/helm >/dev/null || true
fi

echo "Helm kurulumu tamam."
helm version
