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

variable "es_namespace" {
  description = "The namespace where the Elasticsearch cluster is deployed. If not specified, defaults to the same namespace as Kibana."
  type        = string
  default     = null
}

variable "resources" {
  type = object({
    requests = optional(object({
      memory = optional(string, "2Gi")
      cpu    = optional(string, "1")
    }), {})
    limits = optional(object({
      memory = optional(string, "2i")
      cpu    = optional(string, "1")
    }), {})
  })
  description = <<EOF
    Compute resource requirements for the Kibana container.
    Based on official ECK recommendations:
    - requests: Minimum resources required for scheduling (memory: 1Gi, cpu: 0.5)
    - limits: Maximum resources the container can use (memory: 2.5Gi, cpu: 2)
    
    Note: ECK applies a default memory limit of 1Gi if not specified.
    For production workloads, consider setting limits to ensure QoS.
    
    See: https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/manage-compute-resources
  EOF
  default = {
    requests = {
      memory = "1Gi"
      cpu    = "0.5"
    }
    limits = {
      memory = "2.5Gi"
      cpu    = "2"
    }
  }
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
