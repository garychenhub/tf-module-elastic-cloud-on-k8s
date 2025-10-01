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
    requests = object({
      memory = string
      cpu    = string
    })
    limits = object({
      memory = string
      cpu    = string
    })
  })
  description = <<EOF
    Compute resource requirements for the Kibana container.
    Based on official ECK recommendations:
    - requests: Minimum resources required for scheduling
    - limits: Maximum resources the container can use
    
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



variable "kibana_image" {
  description = "Custom Kibana Docker image. If not specified, the default Kibana image will be used."
  type        = string
  default     = null
}




