#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update -y
sudo apt-get install -y gpg curl software-properties-common

if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then
  curl -fsSL https://apt.releases.hashicorp.com/gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
fi

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
| sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null

sudo apt-get update -y
sudo apt-get install -y terraform

echo "Terraform kurulumu tamam."
terraform -version
