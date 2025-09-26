resource "kubernetes_manifest" "es_cluster" {
  manifest = yamldecode(templatefile("${path.module}/templates/es_cluster.yaml.tftpl", {
    es_cluster_name = var.es_cluster_name
    es_version      = var.es_version
    namespace       = var.namespace
    node_sets       = var.node_sets
    global_config   = var.global_config
  }))

  field_manager {
    name            = "terraform"
    force_conflicts = true
  }
}
