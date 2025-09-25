variable "eck_operator_release_name" {
  type        = string
  description = "The name of the Helm release for the ECK operator."
  default     = "eck-operator"
}

variable "chart_version" {
  type        = string
  description = "The version of the eck-operator Helm chart to deploy."
  default     = "3.1.0"
}

variable "eck_deploy_namespace" {
  type        = string
  description = "The Kubernetes namespace where the ECK operator will be deployed."
}

variable "install_crds" {
  type        = bool
  description = <<EOF
      installCRDs determines whether Custom Resource Definitions (CRD) are installed by the chart.
      Note that CRDs are global resources and require cluster admin privileges to install.
      If you are sharing a cluster with other users who may want to install ECK on their own namespaces, setting this to true can have unintended consequences.
      1. Upgrades will overwrite the global CRDs and could disrupt the other users of ECK who may be running a different version.
      2. Uninstalling the chart will delete the CRDs and potentially cause Elastic resources deployed by other users to be removed as well.
    EOF
  default     = true
}
