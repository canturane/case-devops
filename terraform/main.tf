terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.9"
    }
  }
}

provider "kind" {}

# Kind cluster tanımı
resource "kind_cluster" "local" {
  name            = "local-cluster"          # Cluster adı
  node_image      = var.k8s_version          # Versiyon değişkenden alınır
  kubeconfig_path = pathexpand("~/.kube/config")
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    # Control-plane
    node {
      role = "control-plane"

      # 80 ve 443'ü host'a map et (Ingress için)
      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
    }

    # Worker'lar
    node { role = "worker" }
    node { role = "worker" }
  }
}

