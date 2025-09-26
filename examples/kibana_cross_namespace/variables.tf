variable "kibana_name" {
  description = "The name of the Kibana."
  type        = string
  default     = "kibana-cross-ns"
}

variable "kibana_version" {
  description = "The version of the Kibana."
  type        = string
  default     = "8.16.1"
}

variable "kibana_namespace" {
  description = "The namespace to deploy Kibana."
  type        = string
  default     = "kibana-system"
}

variable "replicas" {
  description = "The number of Kibana."
  type        = number
  default     = 1
}

variable "es_cluster_name" {
  description = "The name of the Elasticsearch cluster to connect to."
  type        = string
  default     = "elasticsearch-cluster"
}

variable "es_namespace" {
  description = "The namespace where the Elasticsearch cluster is deployed."
  type        = string
  default     = "elastic-system"
}