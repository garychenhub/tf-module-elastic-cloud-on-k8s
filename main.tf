locals {
  eck_chart_repository        = "https://helm.elastic.co"
  eck_operator_chart_name     = "eck-operator"
  eck_operator_crd_chart_name = "eck-operator-crds"
}

resource "helm_release" "eck_operator" {
  name       = var.eck_operator_release_name
  chart      = local.eck_operator_chart_name
  repository = local.eck_chart_repository
  version    = var.chart_version
  namespace  = var.eck_deploy_namespace
}

resource "helm_release" "eck_operator_crd" {
  name       = var.eck_operator_crd_release_name
  chart      = local.eck_operator_crd_chart_name
  repository = local.eck_chart_repository
  version    = var.chart_version
  namespace  = var.eck_deploy_namespace
}
