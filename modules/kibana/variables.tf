variable "kibana_name" {
  description = "The name of the Kibana."
  type        = string
}

variable "namespace" {
  description = "The namespace to deploy Kibana."
  type        = string
}

variable "kibana_version" {
  description = "The version of the Kibana."
  type        = string
}

variable "replicas" {
  description = "The number of Kibana."
  type        = number
  default     = 1
}

variable "es_cluster_name" {
  description = "The name of the Elasticsearch cluster to connect to."
  type        = string
}

variable "secure_settings" {
  type = list(object({
    secret_name = string
    entries = optional(list(object({
      key  = string
      path = optional(string)
    })), [])
  }))
  description = <<EOF
    List of secure settings to be injected into Kibana keystore from Kubernetes secrets.
    Each object should contain:
    - secret_name: Name of the Kubernetes secret containing the secure settings
    - entries: Optional list of specific entries to project from the secret
      - key: The key in the secret to project
      - path: Optional custom path in the keystore (defaults to the key name)
    
    If entries is empty or not specified, all keys from the secret will be projected
    using their original names as keystore paths.
  EOF
  default     = []
}
