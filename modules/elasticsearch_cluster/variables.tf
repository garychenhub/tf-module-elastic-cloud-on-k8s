variable "es_cluster_name" {
  type        = string
  description = "The name of the Elasticsearch cluster."
}

variable "es_version" {
  type        = string
  description = "The version of Elasticsearch to deploy."
}

variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where the Elasticsearch cluster will be deployed."
}
