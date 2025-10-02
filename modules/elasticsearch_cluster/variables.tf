variable "es_cluster_name" {
  type        = string
  description = "The name of the Elasticsearch cluster."
}

variable "es_version" {
  type        = string
  description = "The version of Elasticsearch to deploy."
}

variable "es_image" {
  description = "Custom Elasticsearch Docker image. If not specified, the default Elasticsearch image will be used."
  type        = string
  default     = null
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
      size          = optional(string, "10Gi")
      storage_class = optional(string, "")
    }), {})
    resources = optional(object({
      requests = optional(object({
        memory = optional(string, "4Gi")
        cpu    = optional(string, "2")
      }), {})
      limits = optional(object({
        memory = optional(string, "4Gi")
        cpu    = optional(string, "2")
      }), {})
    }), {})
  }))
  description = "Configuration for Elasticsearch node sets"
  default = [
    {
      name  = "default"
      count = 1
      config = {
        "node.roles"       = "[\"master\", \"data\", \"ingest\"]"
        "vm.max_map_count" = "262144"
      }
    }
  ]
}

variable "update_strategy" {
  type = object({
    change_budget = optional(object({
      max_surge       = optional(number)
      max_unavailable = optional(number, 1)
    }))
  })
  description = <<EOF
    Pod update strategy configuration to limit the number of simultaneous changes.
    
    change_budget:
      - max_surge: Number of extra Pods that can be temporarily scheduled exceeding 
                   the number of Pods defined in the specification. 
                   null = default value used, negative = unbounded, non-negative = value used as is
      - max_unavailable: Number of Pods that can be unavailable out of the total number 
                         of Pods in the currently applied specification.
                         Default is 1 to ensure cluster stability.
    
    Default behavior when not specified:
      max_surge: -1 (unbounded)
      max_unavailable: 1
    
    See: https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/update-strategy
  EOF
  default = {
    change_budget = {
      max_surge       = -1
      max_unavailable = 1
    }
  }
}



variable "image_pull_policy" {
  type        = string
  description = <<EOF
    Image pull policy for Elasticsearch containers.
    
    Possible values:
    - Always: Always pull the image from the registry
    - IfNotPresent: Pull the image only if it's not present locally (default)
    - Never: Never pull the image from the registry
    
    See: https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy
  EOF
  default     = "IfNotPresent"
  
  validation {
    condition     = contains(["Always", "IfNotPresent", "Never"], var.image_pull_policy)
    error_message = "The image_pull_policy must be one of: Always, IfNotPresent, Never."
  }
}

variable "http" {
  type = object({
    service = optional(object({
      metadata = optional(object({
        labels      = optional(map(string), {})
        annotations = optional(map(string), {})
      }), {})
      spec = optional(object({
        type = optional(string)
      }), {})
    }), {})
  })
  description = <<EOF
    HTTP service configuration for Elasticsearch cluster.
    
    - service.metadata.labels: Custom labels to apply to the HTTP service
    - service.metadata.annotations: Custom annotations to apply to the HTTP service
    - service.spec.type: Kubernetes service type (ClusterIP, LoadBalancer, NodePort)
    
    Examples:
    
    For LoadBalancer (public access):
    {
      service = {
        spec = {
          type = "LoadBalancer"
        }
      }
    }
    
    For Google Cloud Load Balancer with annotations:
    {
      service = {
        metadata = {
          labels = {
            app = "elasticsearch"
          }
          annotations = {
            "cloud.google.com/app-protocols:"           = "'$${jsonencode({ https = "HTTPS" })}'"
            "service.alpha.kubernetes.io/app-protocols" = "'$${jsonencode({ https = "HTTPS" })}'"
            "cloud.google.com/neg"                      = "'$${jsonencode({ ingress = "true" })}'"
          }
        }
        spec = {
          type = "LoadBalancer"
        }
      }
    }
  EOF
  default = null
}

variable "automount_service_account_token" {
  type        = bool
  description = <<EOF
    Indicates whether pods should automatically mount a ServiceAccount token.
    
    This is required for features like:
    - GKE Workload Identity for Google Cloud Storage snapshots
    - AWS IAM roles for service accounts (IRSA) for S3 snapshots
    - Azure Workload Identity for Azure blob storage snapshots
    
    When set to true, the ServiceAccount token will be automatically mounted 
    in the pod, allowing Elasticsearch to authenticate with cloud services.
    
    See: https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore/cloud-on-k8s
  EOF
  default     = false
}

variable "service_account_name" {
  type        = string
  description = <<EOF
    Name of the Kubernetes ServiceAccount to use for the Elasticsearch pods.
    
    This ServiceAccount should be configured with appropriate permissions for:
    - GKE Workload Identity (annotated with iam.gke.io/gcp-service-account)
    - AWS IAM roles for service accounts (IRSA)
    - Azure Workload Identity
    
    Examples:
    - "gcs-sa" for Google Cloud Storage with Workload Identity
    - "aws-sa" for AWS S3 with IRSA
    - "workload-identity-sa" for Azure Workload Identity
    
    If not specified, the default ServiceAccount will be used.
    
    See: https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore/cloud-on-k8s
  EOF
  default     = null
}