resource "kubernetes_manifest" "kibana" {
  manifest = yamldecode(templatefile("${path.module}/templates/kibana.yaml.tftpl", {
    kibana_name     = var.kibana_name
    namespace       = var.namespace
    kibana_version  = var.kibana_version
    replicas        = var.replicas
    es_cluster_name = var.es_cluster_name
    es_namespace    = var.es_namespace != null ? var.es_namespace : var.namespace
    secure_settings = var.secure_settings
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

    # PodTemplate metadata
    "spec.podTemplate.metadata",
    "spec.podTemplate.metadata.creationTimestamp",
    "spec.podTemplate.metadata.labels",
    "spec.podTemplate.metadata.annotations",

    # Status
    "status",
    "status.health",
    "status.availableNodes",
    "status.version",
    "status.observedGeneration"
  ]

  field_manager {
    name            = "terraform"
    force_conflicts = true
  }

  wait {
    fields = {
      "status.health" = "green"
    }
  }
}
