variable "k8s_version" {
  description = "Kind node image (Kubernetes version)"
  type        = string
  default     = "kindest/node:v1.30.0"
}
