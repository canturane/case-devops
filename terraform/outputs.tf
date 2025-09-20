output "cluster_name" {
  description = "Cluster name"
  value       = kind_cluster.local.name
}

output "kubeconfig" {
  description = "Kubeconfig path"
  value       = kind_cluster.local.kubeconfig_path
}
