# resource "kubernetes_manifest" "es_cluster" {
#   manifest = yamldecode(templatefile("${path.module}/templates/es_cluster.yaml.tftpl", {
#     es_cluster_name            = var.es_cluster_name
#     es_version                 = var.es_version
#     es_image                   = var.es_image
#     image_pull_policy          = var.image_pull_policy
#     volume_claim_delete_policy = var.volume_claim_delete_policy
#     namespace                  = var.namespace
#     node_sets                  = var.node_sets
#     global_config              = var.global_config
#     update_strategy            = var.update_strategy
#     http                       = var.http
#   }))
#
#   field_manager {
#     name            = "terraform"
#     force_conflicts = true
#   }
# }

resource "kubectl_manifest" "es_cluster" {
  yaml_body = templatefile("${path.module}/templates/es_cluster.yaml.tftpl", {
    es_cluster_name            = var.es_cluster_name
    es_version                 = var.es_version
    es_image                   = var.es_image
    image_pull_policy          = var.image_pull_policy
    volume_claim_delete_policy = var.volume_claim_delete_policy
    namespace                  = var.namespace
    node_sets                  = var.node_sets
    global_config              = var.global_config
    update_strategy            = var.update_strategy
    http                       = var.http
  })
}
