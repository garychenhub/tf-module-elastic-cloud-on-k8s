locals {
  eck_chart_repository    = "https://helm.elastic.co"
  eck_operator_chart_name = "eck-operator"
}

resource "helm_release" "eck_operator" {
  name       = var.eck_operator_release_name
  chart      = local.eck_operator_chart_name
  repository = local.eck_chart_repository
  version    = var.chart_version
  namespace  = var.eck_deploy_namespace

  # Restricted installation
  set = [
    {
      name  = "installCRDs"
      type  = "string"
      value = var.install_crds ? "true" : "false"
    },
    {
      name  = "managedNamespaces"
      type  = "list"
      value = join(",", var.managed_namespaces)
    },
    {
      name  = "createClusterScopedResources"
      type  = "bool"
      value = var.create_cluster_scoped_resources ? "true" : "false"
    },
    {
      name  = "webhook.enabled"
      type  = "bool"
      value = var.webhook_enable ? "true" : "false"
    },
    {
      name  = "config.validateStorageClass"
      type  = "bool"
      value = var.config_validate_storage_class ? "true" : "false"
    }
  ]
}
