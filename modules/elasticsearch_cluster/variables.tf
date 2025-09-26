variable "es_cluster_name" {
  type        = string
  description = "The name of the Elasticsearch cluster."
}

variable "es_version" {
  type        = string
  description = "The version of Elasticsearch to deploy."
}

variable "volume_claim_delete_policy" {
  type        = string
  description = <<EOF
    The possible values are DeleteOnScaledownAndClusterDeletion and DeleteOnScaledownOnly.
    See: https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/volume-claim-templates#k8s_controlling_volume_claim_deletion
  EOF
  default     = "DeleteOnScaledownAndClusterDeletion"

  validation {
    condition     = contains(["DeleteOnScaledownAndClusterDeletion", "DeleteOnScaledownOnly"], var.volume_claim_delete_policy)
    error_message = "The volume_claim_delete_policy must be either 'DeleteOnScaledownAndClusterDeletion' or 'DeleteOnScaledownOnly'."
  }
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
    name   = string
    count  = number
    config = optional(map(string), {})
    storage = optional(object({
      size          = optional(string, "1Gi")
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
      name  = "default"
      count = 1
      config = {
        "vm.max_map_count" = "262144"
      }
    }
  ]
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
    List of secure settings to be injected into Elasticsearch keystore from Kubernetes secrets.
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
