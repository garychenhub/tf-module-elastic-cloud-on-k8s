resource "kubernetes_manifest" "es_cluster" {
  manifest = yamldecode(templatefile("${path.module}/templates/es_cluster.yaml.tftpl",
    {
      es_cluster_name = var.es_cluster_name
      es_version      = var.es_version
      namespace       = var.namespace
    }
  ))
}
