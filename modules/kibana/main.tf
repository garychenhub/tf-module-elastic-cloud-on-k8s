resource "kubernetes_manifest" "kibana" {
  manifest = yamldecode(templatefile("${path.module}/templates/kibana.yaml.tftpl", {
    kibana_name     = var.kibana_name
    namespace       = var.namespace
    kibana_version  = var.kibana_version
    kibana_image    = var.kibana_image
    replicas        = var.replicas
    es_cluster_name = var.es_cluster_name
    es_namespace    = var.es_namespace != null ? var.es_namespace : var.namespace
    resources       = var.resources
  }))

  computed_fields = [
    # metadata
    "metadata.annotations",
    "metadata.finalizers",
    "metadata.generation",
    "metadata.managedFields",
    "metadata.resourceVersion",
    "metadata.uid",
    "metadata.creationTimestamp",
    "metadata.deletionGracePeriodSeconds",
    "metadata.deletionTimestamp",

    # PodTemplate metadata
    "spec.podTemplate.metadata",
    "spec.podTemplate.metadata.creationTimestamp",
    "spec.podTemplate.metadata.labels",
    "spec.podTemplate.metadata.annotations",
    "spec.podTemplate.spec.containers",

    # Status
    "status",
    "status.health",
    "status.availableNodes",
    "status.version",
    "status.observedGeneration"
  ]

  # computed_fields = [
  #   "metadata.labels",
  #   "metadata.annotations",
  #   "spec.finalizers",
  #   "spec.nodeSets",
  #   "spec.podTemplate",
  #   "status"
  # ]

  # field_manager {
  #   name            = "terraform"
  #   force_conflicts = true
  # }

  wait {
    fields = {
      "status.health" = "green"
    }
  }
}
