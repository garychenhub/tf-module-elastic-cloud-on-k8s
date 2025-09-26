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

### <a name="input_replicas"></a> [replicas](#input\_replicas)

Description: The number of Kibana.

Type: `number`

Default: `1`

## Outputs

No outputs.
