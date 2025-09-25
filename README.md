## Requirements

The following requirements are needed by this module:

- <a name="requirement_helm"></a> [helm](#requirement\_helm) (~> 3.0)

## Providers

The following providers are used by this module:

- <a name="provider_helm"></a> [helm](#provider\_helm) (~> 3.0)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [helm_release.eck_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_eck_deploy_namespace"></a> [eck\_deploy\_namespace](#input\_eck\_deploy\_namespace)

Description: The Kubernetes namespace where the ECK operator will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version)

Description: The version of the eck-operator Helm chart to deploy.

Type: `string`

Default: `"3.1.0"`

### <a name="input_eck_operator_release_name"></a> [eck\_operator\_release\_name](#input\_eck\_operator\_release\_name)

Description: The name of the Helm release for the ECK operator.

Type: `string`

Default: `"eck-operator"`

### <a name="input_install_crds"></a> [install\_crds](#input\_install\_crds)

Description:       installCRDs determines whether Custom Resource Definitions (CRD) are installed by the chart.  
      Note that CRDs are global resources and require cluster admin privileges to install.  
      If you are sharing a cluster with other users who may want to install ECK on their own namespaces, setting this to true can have unintended consequences.  
      1. Upgrades will overwrite the global CRDs and could disrupt the other users of ECK who may be running a different version.  
      2. Uninstalling the chart will delete the CRDs and potentially cause Elastic resources deployed by other users to be removed as well.

Type: `bool`

Default: `true`

## Outputs

No outputs.
