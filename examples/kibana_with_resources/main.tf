# 範例：不同資源配置的 Kibana 部署
# 此範例展示如何為不同使用場景配置 Kibana 資源

# 開發環境 - 最小資源配置
module "kibana_dev" {
  source = "../../modules/kibana"

  kibana_name     = "${var.kibana_name}-dev"
  kibana_version  = var.kibana_version
  namespace       = var.namespace
  replicas        = 1
  es_cluster_name = var.es_cluster_name

  # 開發環境的輕量配置
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

# 生產環境 - 標準配置（官方建議）
module "kibana_prod" {
  source = "../../modules/kibana"

  kibana_name     = "${var.kibana_name}-prod"
  kibana_version  = var.kibana_version
  namespace       = var.namespace
  replicas        = 2
  es_cluster_name = var.es_cluster_name

  # 生產環境標準配置
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

# 高負載環境 - 高資源配置
module "kibana_high_load" {
  source = "../../modules/kibana"

  kibana_name     = "${var.kibana_name}-high-load"
  kibana_version  = var.kibana_version
  namespace       = var.namespace
  replicas        = 3
  es_cluster_name = var.es_cluster_name

  # 高負載環境配置
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

# Guaranteed QoS - requests 和 limits 相同
module "kibana_guaranteed_qos" {
  source = "../../modules/kibana"

  kibana_name     = "${var.kibana_name}-guaranteed"
  kibana_version  = var.kibana_version
  namespace       = var.namespace
  replicas        = 1
  es_cluster_name = var.es_cluster_name

  # Guaranteed QoS 配置
  resources = {
    requests = {
      memory = "2Gi"
      cpu    = "1"
    }
    limits = {
      memory = "2Gi" # 與 requests 相同
      cpu    = "1"   # 與 requests 相同
    }
  }
}