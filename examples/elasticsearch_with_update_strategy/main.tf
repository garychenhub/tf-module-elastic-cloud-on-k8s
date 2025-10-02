# Example: Elasticsearch cluster with Update Strategy
# This example demonstrates how to configure Elasticsearch cluster update strategies to co      # -1 means unlimited (default behavior)
#      max_surge = -1

      # Allow more Pods to be unavailable simultaneously, speeding up updatesl the number of simultaneous Pod changes

# Elasticsearch cluster with Update Strategy
module "elasticsearch_cluster_with_update_strategy" {
  source = "../../modules/elasticsearch_cluster"

  es_cluster_name = var.es_cluster_name
  es_version      = var.es_version
  namespace       = var.namespace

  global_config = {
    "node.store.allow_mmap"  = false
    "xpack.security.enabled" = true
  }

  node_sets = [
    {
      name  = "master"
      count = 3
      config = {
        "node.roles" = "[\"master\"]"
      }
      resources = {
        requests = {
          memory = "2Gi"
          cpu    = "1"
        }
        limits = {
          memory = "4Gi"
          cpu    = "2"
        }
      }
      storage = {
        size          = "10Gi"
        storage_class = "fast-ssd"
      }
    },
    {
      name  = "data"
      count = 6
      config = {
        "node.roles" = "[\"data\", \"ingest\"]"
      }
      resources = {
        requests = {
          memory = "4Gi"
          cpu    = "2"
        }
        limits = {
          memory = "8Gi"
          cpu    = "4"
        }
      }
      storage = {
        size          = "100Gi"
        storage_class = "fast-ssd"
      }
    },
    {
      name  = "coordinating"
      count = 2
      config = {
        "node.roles" = "[\"remote_cluster_client\"]"
      }
      resources = {
        requests = {
          memory = "1Gi"
          cpu    = "500m"
        }
        limits = {
          memory = "2Gi"
          cpu    = "1"
        }
      }
    }
  ]

  # Configure Update Strategy
  # This setting limits the number of Pods updated simultaneously, ensuring cluster stability
  update_strategy = {
    change_budget = {
      # Allow up to 3 additional Pods to be created simultaneously
      # This controls resource usage when nodeSet configurations change
      max_surge = 3

      # Allow up to 2 Pods to be unavailable simultaneously
      # Ensures the cluster maintains sufficient available nodes during updates
      max_unavailable = 2
    }
  }
}

# Example: Conservative update strategy (suitable for production environments)
module "elasticsearch_cluster_conservative" {
  source = "../../modules/elasticsearch_cluster"

  es_cluster_name = "${var.es_cluster_name}-conservative"
  es_version      = var.es_version
  namespace       = var.namespace

  node_sets = [
    {
      name  = "default"
      count = 5
      config = {
        "node.roles" = "[\"master\", \"data\", \"ingest\"]"
      }
    }
  ]

  # Conservative update strategy: update only one Pod at a time, avoid creating extra Pods
  update_strategy = {
    change_budget = {
      # Do not allow creating extra Pods, saving resources
      max_surge = 0

      # Only allow one Pod to be unavailable at a time, ensuring maximum stability
      max_unavailable = 1
    }
  }
}

# Example: Fast update strategy (suitable for development environments)
module "elasticsearch_cluster_fast" {
  source = "../../modules/elasticsearch_cluster"

  es_cluster_name = "${var.es_cluster_name}-fast"
  es_version      = var.es_version
  namespace       = var.namespace

  node_sets = [
    {
      name  = "default"
      count = 3
      config = {
        "node.roles" = "[\"master\", \"data\", \"ingest\"]"
      }
    }
  ]

  # Fast update strategy: allow unlimited extra Pods and multiple Pods to be unavailable simultaneously
  update_strategy = {
    change_budget = {
      # -1 means unlimited (default behavior)
      max_surge = -1

      # 允許更多 Pod 同時不可用，加快更新速度
      max_unavailable = 2
    }
  }
}