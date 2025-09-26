# 範例：使用 Update Strategy 的 Elasticsearch 集群
# 此範例展示如何配置 Elasticsearch 集群的更新策略以控制 Pod 的同時變更數量

# 使用 Update Strategy 的 Elasticsearch 集群
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

  # 配置 Update Strategy
  # 這個設定限制了同時更新的 Pod 數量，確保集群穩定性
  update_strategy = {
    change_budget = {
      # 最多允許同時創建 3 個額外的 Pod
      # 這在 nodeSet 配置變更時控制資源使用
      max_surge = 3

      # 最多允許同時有 2 個 Pod 不可用
      # 確保集群在更新過程中保持足夠的可用節點
      max_unavailable = 2
    }
  }
}

# 範例：保守的更新策略（適用於生產環境）
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

  # 保守的更新策略：一次只更新一個 Pod，避免創建額外 Pod
  update_strategy = {
    change_budget = {
      # 不允許創建額外的 Pod，節省資源
      max_surge = 0

      # 一次只允許一個 Pod 不可用，確保最大穩定性
      max_unavailable = 1
    }
  }
}

# 範例：快速更新策略（適用於開發環境）
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

  # 快速更新策略：允許無限制的額外 Pod 和多個 Pod 同時不可用
  update_strategy = {
    change_budget = {
      # -1 表示無限制（默認行為）
      max_surge = -1

      # 允許更多 Pod 同時不可用，加快更新速度
      max_unavailable = 2
    }
  }
}