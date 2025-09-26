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

variable "global_config" {
  type        = map(any)
  description = "Global Elasticsearch configuration applied to all node sets"
  default     = {}
}

variable "node_sets" {
  type = list(object({
    name    = string
    count   = number
    config  = optional(map(any), {})
    storage = optional(object({
      size         = optional(string, "1Gi")
      storage_class = optional(string, "")
    }), {})
    resources = optional(object({
      requests = optional(object({
        memory = optional(string, "1Gi")
        cpu    = optional(string, "500m")
      }), {})
      limits = optional(object({
        memory = optional(string, "2Gi")
        cpu    = optional(string, "1")
      }), {})
    }), {})
  }))
  description = "Configuration for Elasticsearch node sets"
  default = [
    {
      name   = "default"
      count  = 1
      config = {
        "node.store.allow_mmap" = false
      }
    }
  ]
}
