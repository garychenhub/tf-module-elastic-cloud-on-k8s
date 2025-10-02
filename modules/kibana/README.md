# Kibana Module

This module creates a Kibana instance using the Elastic Cloud on Kubernetes (ECK) operator.

## Requirements

The following requirements are needed by this module:

- kubectl (~> 1.19.0)

## Providers

The following providers are used by this module:

- kubectl (~> 1.19.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [kubectl_manifest.kibana](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) (resource)

## Required Inputs

The following input variables are required:

### es_cluster_name

Description: The name of the Elasticsearch cluster to connect to.

Type: `string`

### kibana_name

Description: The name of the Kibana instance.

Type: `string`

### kibana_version

Description: The version of Kibana to deploy.

Type: `string`

### namespace

Description: The namespace to deploy Kibana.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### es_namespace

Description: The namespace where the Elasticsearch cluster is deployed. If not specified, defaults to the same namespace as Kibana.

Type: `string`

Default: `null`

### http

Description: HTTP service configuration for Kibana.

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
        app = "kibana"
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

### kibana_image

Description: Custom Kibana Docker image. If not specified, the default Kibana image will be used.

Type: `string`

Default: `null`

### replicas

Description: The number of Kibana replicas.

Type: `number`

Default: `1`

### resources

Description: Compute resource requirements for the Kibana container.

Based on official ECK recommendations:

- requests: Minimum resources required for scheduling
- limits: Maximum resources the container can use

Note: ECK applies a default memory limit of 1Gi if not specified. For production workloads, consider setting limits to ensure QoS.

See: <https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/manage-compute-resources>

Type:

```hcl
object({
  requests = object({
    memory = string
    cpu    = string
  })
  limits = object({
    memory = string
    cpu    = string
  })
})
```

Default:

```hcl
{
  requests = {
    memory = "1Gi"
    cpu    = "0.5"
  }
  limits = {
    memory = "2.5Gi"
    cpu    = "2"
  }
}
```

## Outputs

No outputs.

## Example Usage

### Basic Example

```hcl
module "kibana" {
  source = "./modules/kibana"

  kibana_name     = "my-kibana"
  kibana_version  = "8.16.1"
  namespace       = "elastic-system"
  es_cluster_name = "my-elasticsearch"
}
```

### With LoadBalancer and Custom Resources

```hcl
module "kibana" {
  source = "./modules/kibana"

  kibana_name     = "my-kibana"
  kibana_version  = "8.16.1"
  namespace       = "elastic-system"
  es_cluster_name = "my-elasticsearch"

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

  # Custom resource allocation
  resources = {
    requests = {
      memory = "2Gi"
      cpu    = "1"
    }
    limits = {
      memory = "4Gi"
      cpu    = "2"
    }
  }

  replicas = 2
}
