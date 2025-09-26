# 範例：跨 Namespace 的 Kibana 和 Elasticsearch
# 此範例展示如何在不同 namespace 中部署 Kibana 和 Elasticsearch

# 使用跨 namespace 配置的 Kibana
module "kibana_cross_namespace" {
  source = "../../modules/kibana"

  kibana_name     = var.kibana_name
  kibana_version  = var.kibana_version
  namespace       = var.kibana_namespace # Kibana 部署在這個 namespace
  replicas        = var.replicas
  es_cluster_name = var.es_cluster_name
  es_namespace    = var.es_namespace # Elasticsearch 在不同的 namespace

  # 資源配置 - 針對跨 namespace 場景的建議配置
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

  # 可選：配置 Secure Settings
  secure_settings = []
}