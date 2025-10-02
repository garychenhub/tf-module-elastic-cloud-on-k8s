# Example: Kibana deployment with different resource configurations
# This example demonstrates how to configure Kibana resources for different use cases

# Development environment - minimal resource configuration
module "kibana_dev" {
  source = "../../modules/kibana"

  kibana_name     = "${var.kibana_name}-dev"
  kibana_version  = var.kibana_version
  namespace       = var.namespace
  replicas        = 1
  es_cluster_name = var.es_cluster_name

  # Lightweight configuration for development environment
  resources = {
    requests = {
      memory = "512Mi"
      cpu    = "0.25"
    }
    limits = {
      memory = "1Gi"
      cpu    = "1"
    }
  }
}

# Production environment - standard configuration (official recommendation)
module "kibana_prod" {
  source = "../../modules/kibana"

  kibana_name     = "${var.kibana_name}-prod"
  kibana_version  = var.kibana_version
  namespace       = var.namespace
  replicas        = 2
  es_cluster_name = var.es_cluster_name

  # Standard production environment configuration
  resources = {
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

# High-load environment - high resource configuration
module "kibana_high_load" {
  source = "../../modules/kibana"

  kibana_name     = "${var.kibana_name}-high-load"
  kibana_version  = var.kibana_version
  namespace       = var.namespace
  replicas        = 3
  es_cluster_name = var.es_cluster_name

  # High-load environment configuration
  resources = {
    requests = {
      memory = "2Gi"
      cpu    = "1"
    }
    limits = {
      memory = "4Gi"
      cpu    = "4"
    }
  }
}

# Guaranteed QoS - requests and limits are identical
module "kibana_guaranteed_qos" {
  source = "../../modules/kibana"

  kibana_name     = "${var.kibana_name}-guaranteed"
  kibana_version  = var.kibana_version
  namespace       = var.namespace
  replicas        = 1
  es_cluster_name = var.es_cluster_name

  # Guaranteed QoS configuration
  resources = {
    requests = {
      memory = "2Gi"
      cpu    = "1"
    }
    limits = {
      memory = "2Gi" # Same as requests
      cpu    = "1"   # Same as requests
    }
  }
}