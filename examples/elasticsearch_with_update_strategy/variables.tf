variable "es_cluster_name" {
  type        = string
  description = "The name of the Elasticsearch cluster."
  default     = "elasticsearch-update-strategy"
}

variable "es_version" {
  type        = string
  description = "The version of Elasticsearch to deploy."
  default     = "8.16.1"
}

variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where the Elasticsearch cluster will be deployed."
  default     = "elastic-system"
}