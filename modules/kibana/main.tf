resource "kubectl_manifest" "kibana" {
  yaml_body = templatefile("${path.module}/templates/kibana.yaml.tftpl", {
    kibana_name     = var.kibana_name
    namespace       = var.namespace
    kibana_version  = var.kibana_version
    kibana_image    = var.kibana_image
    replicas        = var.replicas
    es_cluster_name = var.es_cluster_name
    es_namespace    = var.es_namespace != null ? var.es_namespace : var.namespace
    resources       = var.resources
    http            = var.http
  })
}