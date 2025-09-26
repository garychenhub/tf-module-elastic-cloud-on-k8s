variable "kibana_name" {
  description = "The base name for Kibana instances."
  type        = string
  default     = "kibana-resources"
}

variable "kibana_version" {
  description = "The version of the Kibana."
  type        = string
  default     = "8.16.1"
}

variable "namespace" {
  description = "The namespace to deploy Kibana."
  type        = string
  default     = "elastic-system"
}

variable "es_cluster_name" {
  description = "The name of the Elasticsearch cluster to connect to."
  type        = string
  default     = "elasticsearch-cluster"
}