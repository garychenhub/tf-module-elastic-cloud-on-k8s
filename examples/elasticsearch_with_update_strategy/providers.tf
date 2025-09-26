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
  # 配置您的 Kubernetes 提供者設定
  # 例如：config_path = "~/.kube/config"
}