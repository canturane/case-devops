#!/usr/bin/env bash
set -euo pipefail
ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
  amd64) KARCH=amd64 ;;
  arm64) KARCH=arm64 ;;
  *) echo "unsupported arch: $ARCH" >&2; exit 1 ;;
esac
VER="v0.23.0"
curl -L -o kind "https://github.com/kubernetes-sigs/kind/releases/download/${VER}/kind-linux-${KARCH}"
sudo install -o root -g root -m 0755 kind /usr/local/bin/kind
rm -f kind
echo "✅ kind $(kind --version) installed."
