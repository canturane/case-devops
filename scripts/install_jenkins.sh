#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update -y
sudo apt-get install -y fontconfig openjdk-17-jre gnupg curl

if [ ! -f /usr/share/keyrings/jenkins-keyring.asc ]; then
  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
  | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
fi

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" \
| sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins

sudo systemctl enable --now jenkins

if getent group docker >/dev/null; then
  sudo usermod -aG docker jenkins || true
fi

if command -v ufw >/dev/null 2>&1; then
  if sudo ufw status | grep -q "Status: active"; then
    sudo ufw allow 8080/tcp || true
  fi
fi

echo "Jenkins kurulumu tamam."
echo "İlk admin şifresi (eğer hazırsa):"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword || true
