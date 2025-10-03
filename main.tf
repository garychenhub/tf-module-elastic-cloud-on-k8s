locals {
  eck_chart_repository    = "https://helm.elastic.co"
  eck_operator_chart_name = "eck-operator"
}

resource "helm_release" "eck_operator" {
  name          = var.eck_operator_release_name
  chart         = local.eck_operator_chart_name
  repository    = local.eck_chart_repository
  version       = var.chart_version
  namespace     = var.eck_deploy_namespace
  wait          = true
  wait_for_jobs = true

  # Restricted installation
  set = [
    {
      name  = "installCRDs"
      value = var.install_crds ? "true" : "false"
    },
    {
      name  = "createClusterScopedResources"
      value = var.create_cluster_scoped_resources ? "true" : "false"
    },
    {
      name  = "webhook.enabled"
      value = var.webhook_enable ? "true" : "false"
    },
    {
      name  = "config.validateStorageClass"
      value = var.config_validate_storage_class ? "true" : "false"
    }
  ]

  set_list = [
    {
      name  = "managedNamespaces"
      value = var.managed_namespaces
    },
  ]
}
