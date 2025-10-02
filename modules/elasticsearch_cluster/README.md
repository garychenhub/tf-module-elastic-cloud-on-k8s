# Elasticsearch Cluster Module

This module creates an Elasticsearch cluster using the Elastic Cloud on Kubernetes (ECK) operator.

## Requirements

The following requirements are needed by this module:

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.37)
- <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) (~> 1.19.0)

## Providers

The following providers are used by this module:

- <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) (~> 1.19.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [kubectl_manifest.es_cluster](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) (resource)

## Required Inputs

The following input variables are required:

### es_cluster_name

Description: The name of the Elasticsearch cluster.

Type: `string`

### es_version

Description: The version of Elasticsearch to deploy.

Type: `string`

### namespace

Description: The Kubernetes namespace where the Elasticsearch cluster will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### automount_service_account_token

Description: Indicates whether pods should automatically mount a ServiceAccount token.

This is required for features like:

- GKE Workload Identity for Google Cloud Storage snapshots
- AWS IAM roles for service accounts (IRSA) for S3 snapshots
- Azure Workload Identity for Azure blob storage snapshots

When set to true, the ServiceAccount token will be automatically mounted in the pod, allowing Elasticsearch to authenticate with cloud services.

See: <https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore/cloud-on-k8s>

Type: `bool`

Default: `false`

### es_image

Description: Custom Elasticsearch Docker image. If not specified, the default Elasticsearch image will be used.

Type: `string`

Default: `null`

### global_config

Description: Global Elasticsearch configuration applied to all node sets

Type: `map(any)`

Default: `{}`

### http

Description: HTTP service configuration for Elasticsearch cluster.

- service.metadata.labels: Custom labels to apply to the HTTP service
- service.metadata.annotations: Custom annotations to apply to the HTTP service
- service.spec.type: Kubernetes service type (ClusterIP, LoadBalancer, NodePort)

Examples:

For LoadBalancer (public access):

```hcl
{
  service = {
    spec = {
      type = "LoadBalancer"
    }
  }
}
```

For Google Cloud Load Balancer with annotations:

```hcl
{
  service = {
    metadata = {
      labels = {
        app = "elasticsearch"
      }
      annotations = {
        "cloud.google.com/app-protocols:"           = "'${jsonencode({ https = "HTTPS" })}'"
        "service.alpha.kubernetes.io/app-protocols" = "'${jsonencode({ https = "HTTPS" })}'"
        "cloud.google.com/neg"                      = "'${jsonencode({ ingress = "true" })}'"
      }
    }
    spec = {
      type = "LoadBalancer"
    }
  }
}
```

Type:

```hcl
object({
  service = optional(object({
    metadata = optional(object({
      labels      = optional(map(string), {})
      annotations = optional(map(string), {})
    }), {})
    spec = optional(object({
      type = optional(string)
    }), {})
  }), {})
})
```

Default: `null`

### image_pull_policy

Description: Image pull policy for Elasticsearch containers.

Possible values:

- Always: Always pull the image from the registry
- IfNotPresent: Pull the image only if it's not present locally (default)
- Never: Never pull the image from the registry

See: <https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy>

Type: `string`

Default: `"IfNotPresent"`

### node_sets

Description: Configuration for Elasticsearch node sets

Type:

```hcl
list(object({
  name   = string
  count  = number
  config = optional(map(string), {})
  storage = optional(object({
    size          = optional(string, "10Gi")
    storage_class = optional(string, "")
  }), {})
  resources = optional(object({
    requests = optional(object({
      memory = optional(string, "4Gi")
      cpu    = optional(string, "2")
    }), {})
    limits = optional(object({
      memory = optional(string, "4Gi")
      cpu    = optional(string, "2")
    }), {})
  }), {})
}))
```

Default:

```json
[
  {
    "config": {
      "node.roles": "[\"master\", \"data\", \"ingest\"]",
      "vm.max_map_count": "262144"
    },
    "count": 1,
    "name": "default"
  }
]
```

### service_account_name

Description: Name of the Kubernetes ServiceAccount to use for the Elasticsearch pods.

This ServiceAccount should be configured with appropriate permissions for:

- GKE Workload Identity (annotated with iam.gke.io/gcp-service-account)
- AWS IAM roles for service accounts (IRSA)
- Azure Workload Identity

Examples:

- "gcs-sa" for Google Cloud Storage with Workload Identity
- "aws-sa" for AWS S3 with IRSA
- "workload-identity-sa" for Azure Workload Identity

If not specified, the default ServiceAccount will be used.

See: <https://www.elastic.co/docs/deploy-manage/tools/snapshot-and-restore/cloud-on-k8s>

Type: `string`

Default: `null`

### update_strategy

Description: Pod update strategy configuration to limit the number of simultaneous changes.

change_budget:

- max_surge: Number of extra Pods that can be temporarily scheduled exceeding the number of Pods defined in the specification. null = default value used, negative = unbounded, non-negative = value used as is
- max_unavailable: Number of Pods that can be unavailable out of the total number of Pods in the currently applied specification. Default is 1 to ensure cluster stability.

Default behavior when not specified:
max_surge: -1 (unbounded)
max_unavailable: 1

See: <https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/update-strategy>

Type:

```hcl
object({
  change_budget = optional(object({
    max_surge       = optional(number)
    max_unavailable = optional(number, 1)
  }))
})
```

Default:

```hcl
{
  change_budget = {
    max_surge       = -1
    max_unavailable = 1
  }
}
```

### volume_claim_delete_policy

Description: The possible values are DeleteOnScaledownAndClusterDeletion and DeleteOnScaledownOnly.

See: <https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/volume-claim-templates#k8s_controlling_volume_claim_deletion>

Type: `string`

Default: `"DeleteOnScaledownAndClusterDeletion"`

## Outputs

No outputs.

## Example Usage

### Basic Example

```hcl
module "elasticsearch" {
  source = "./modules/elasticsearch_cluster"

  es_cluster_name = "my-es-cluster"
  es_version      = "8.16.1"
  namespace       = "elastic-system"
  
  node_sets = [
    {
      name  = "default"
      count = 3
      config = {
        "node.roles" = "[\"master\", \"data\", \"ingest\"]"
      }
      storage = {
        size          = "100Gi"
        storage_class = "ssd"
      }
      resources = {
        requests = {
          memory = "8Gi"
          cpu    = "4"
        }
        limits = {
          memory = "8Gi"
          cpu    = "4"
        }
      }
    }
  ]
}
```

### With LoadBalancer and GKE Workload Identity

```hcl
module "elasticsearch" {
  source = "./modules/elasticsearch_cluster"

  es_cluster_name = "my-es-cluster"
  es_version      = "8.16.1"
  namespace       = "elastic-system"

  # Enable LoadBalancer with GCP annotations
  http = {
    service = {
      metadata = {
        annotations = {
          "cloud.google.com/app-protocols"            = "{\"https\": \"HTTPS\"}"
          "service.alpha.kubernetes.io/app-protocols" = "{\"https\": \"HTTPS\"}"
          "cloud.google.com/neg"                      = "{\"ingress\": \"true\"}"
        }
      }
      spec = {
        type = "LoadBalancer"
      }
    }
  }

  # Enable Workload Identity for snapshots
  automount_service_account_token = true
  service_account_name            = "gcs-sa"
  
  node_sets = [
    {
      name  = "default"
      count = 3
      config = {
        "node.roles" = "[\"master\", \"data\", \"ingest\"]"
      }
    }
  ]
}
```
