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

variable "eck_operator_crds_release_name" {
  type        = string
  description = "The name of the Helm release for the ECK operator CRDs."
  default     = "eck-operator-crds"
}
