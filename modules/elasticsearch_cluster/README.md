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

- [kubernetes_manifest.es_cluster](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_es_cluster_name"></a> [es\_cluster\_name](#input\_es\_cluster\_name)

Description: The name of the Elasticsearch cluster.

Type: `string`

### <a name="input_es_version"></a> [es\_version](#input\_es\_version)

Description: The version of Elasticsearch to deploy.

Type: `string`

### <a name="input_namespace"></a> [namespace](#input\_namespace)

Description: The Kubernetes namespace where the Elasticsearch cluster will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_global_config"></a> [global\_config](#input\_global\_config)

Description: Global Elasticsearch configuration applied to all node sets

Type: `map(any)`

Default: `{}`

### <a name="input_node_sets"></a> [node\_sets](#input\_node\_sets)

Description: Configuration for Elasticsearch node sets

Type:

```hcl
list(object({
    name    = string
    count   = number
    config  = optional(map(string), {})
    storage = optional(object({
      size         = optional(string, "1Gi")
      storage_class = optional(string, "")
    }), {})
    resources = optional(object({
      requests = optional(object({
        memory = optional(string, "1Gi")
        cpu    = optional(string, "500m")
      }), {})
      limits = optional(object({
        memory = optional(string, "2Gi")
        cpu    = optional(string, "1")
      }), {})
    }), {})
  }))
```

Default:

```json
[
  {
    "config": {
      "vm.max_map_count": "262144"
    },
    "count": 1,
    "name": "default"
  }
]
```

### <a name="input_secure_settings"></a> [secure\_settings](#input\_secure\_settings)

Description: List of secure settings to be injected into Elasticsearch keystore from Kubernetes secrets.
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

### <a name="input_volume_claim_delete_policy"></a> [volume\_claim\_delete\_policy](#input\_volume\_claim\_delete\_policy)

Description: The possible values are DeleteOnScaledownAndClusterDeletion and DeleteOnScaledownOnly.
See: https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/volume-claim-templates#k8s_controlling_volume_claim_deletion

Type: `string`

Default: `"DeleteOnScaledownAndClusterDeletion"`

## Outputs

No outputs.
