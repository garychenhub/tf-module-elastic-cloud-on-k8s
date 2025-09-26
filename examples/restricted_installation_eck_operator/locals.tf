locals {
  home_directory = data.external.home_directory.result.home

  # Cluster
  cluster_name = "kind-kind"
  config_path  = "${local.home_directory}/.kube/config"
}

