resource "kubernetes_namespace_v1" "elastic_system" {
  metadata {
    name = "elastic-system"
  }
}

module "eck_cloud_on_k8s" {
  source = "../.."

  eck_deploy_namespace = kubernetes_namespace_v1.elastic_system.metadata[0].name
  chart_version        = "3.1.0"

  install_crds                    = true
  managed_namespaces              = ["elastic-system"]
  create_cluster_scoped_resources = false
  webhook_enable                  = false
  config_validate_storage_class   = false

  depends_on = [kubernetes_namespace_v1.elastic_system]
}

module "es_cluster" {
  source = "../../modules/elasticsearch_cluster"

  es_cluster_name = "demo-es-cluster"
  es_version      = "9.1.4"
  namespace       = kubernetes_namespace_v1.elastic_system.metadata[0].name
}
