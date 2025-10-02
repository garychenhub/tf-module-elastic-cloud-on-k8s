# Example: Cross-Namespace Kibana and Elasticsearch
# This example demonstrates how to deploy Kibana and Elasticsearch in different namespaces

# Kibana with cross-namespace configuration
module "kibana_cross_namespace" {
  source = "../../modules/kibana"

  kibana_name     = var.kibana_name
  kibana_version  = var.kibana_version
  namespace       = var.kibana_namespace # Kibana is deployed in this namespace
  replicas        = var.replicas
  es_cluster_name = var.es_cluster_name
  es_namespace    = var.es_namespace # Elasticsearch is in a different namespace

  # Resource configuration - recommended settings for cross-namespace scenarios
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