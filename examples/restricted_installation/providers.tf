terraform {
  required_version = "~> 1.10"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

provider "kubernetes" {
  config_path    = local.config_path
  config_context = local.cluster_name
}

provider "helm" {
  kubernetes = {
    config_path    = local.config_path
    config_context = local.cluster_name
  }
}
