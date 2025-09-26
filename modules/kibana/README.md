## Requirements

The following requirements are needed by this module:

- <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) (~> 2.0)

## Providers

The following providers are used by this module:

- <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) (~> 2.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [kubernetes_manifest.kibana](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_es_cluster_name"></a> [es\_cluster\_name](#input\_es\_cluster\_name)

Description: The name of the Elasticsearch cluster to connect to.

Type: `string`

### <a name="input_kibana_name"></a> [kibana\_name](#input\_kibana\_name)

Description: The name of the Kibana.

Type: `string`

### <a name="input_kibana_version"></a> [kibana\_version](#input\_kibana\_version)

Description: The version of the Kibana.

Type: `string`

### <a name="input_namespace"></a> [namespace](#input\_namespace)

Description: The namespace to deploy Kibana.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_es_namespace"></a> [es\_namespace](#input\_es\_namespace)

Description: The namespace where the Elasticsearch cluster is deployed. If not specified, defaults to the same namespace as Kibana.

Type: `string`

Default: `null`

### <a name="input_replicas"></a> [replicas](#input\_replicas)

Description: The number of Kibana.

Type: `number`

Default: `1`

### <a name="input_resources"></a> [resources](#input\_resources)

Description: Compute resource requirements for the Kibana container.
Based on official ECK recommendations:
- requests: Minimum resources required for scheduling (memory: 1Gi, cpu: 0.5)
- limits: Maximum resources the container can use (memory: 2.5Gi, cpu: 2)

Note: ECK applies a default memory limit of 1Gi if not specified.
For production workloads, consider setting limits to ensure QoS.

See: https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/manage-compute-resources

Type:

```hcl
object({
    requests = optional(object({
      memory = optional(string, "1Gi")
      cpu    = optional(string, "0.5")
    }), {})
    limits = optional(object({
      memory = optional(string, "2.5Gi")
      cpu    = optional(string, "2")
    }), {})
  })
```

Default:

```hcl
{
  limits = {
    cpu = "2"
    memory = "2.5Gi"
  }
  requests = {
    cpu = "0.5"
    memory = "1Gi"
  }
}
```

### <a name="input_secure_settings"></a> [secure\_settings](#input\_secure\_settings)

Description: List of secure settings to be injected into Kibana keystore from Kubernetes secrets.
Each object should contain:
- secret\_name: Name of the Kubernetes secret containing the secure settings
- entries: Optional list of specific entries to project from the secret
  - key: The key in the secret to project
  - path: Optional custom path in the keystore (defaults to the key name)

If entries is empty or not specified, all keys from the secret will be projected
using their original names as keystore paths.

Type:

```hcl
list(object({
    secret_name = string
    entries = optional(list(object({
      key  = string
      path = optional(string)
    })), [])
  }))
```

Default: `[]`

## Outputs

No outputs.
