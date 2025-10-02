terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  required_version = ">= 1.0"
}

provider "kubernetes" {
  # Configure your Kubernetes provider settings
  # For example: config_path = "~/.kube/config"
}