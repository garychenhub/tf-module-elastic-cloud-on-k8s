# Kibana Cross-Namespace Example

This example demonstrates how to deploy Kibana and Elasticsearch in different Kubernetes namespaces, which is useful in multi-tenant environments or scenarios requiring logical separation.

## Use Cases

Use cross-namespace configuration when you need:

1. **Multi-tenant environments**: Different teams or applications using different namespaces
2. **Logical separation**: Separating search backend (Elasticsearch) and frontend (Kibana)
3. **Access control**: Different namespaces with different RBAC permissions
4. **Resource isolation**: Better resource quotas and limits management

## Configuration Overview

In this example:
- Kibana is deployed in the `kibana-system` namespace
- Elasticsearch cluster is in the `elastic-system` namespace
- Cross-namespace reference is specified through the `es_namespace` parameter

## Important Considerations

1. **Service Discovery**: ECK operator automatically handles cross-namespace service discovery
2. **Network Policies**: Ensure network connectivity between namespaces
3. **RBAC Permissions**: Ensure Kibana has permission to access services in the Elasticsearch namespace
4. **TLS Certificates**: ECK automatically handles cross-namespace TLS communication

## Deployment Steps

1. Ensure both namespaces are created:
```bash
kubectl create namespace kibana-system
kubectl create namespace elastic-system
```

2. First deploy the Elasticsearch cluster (in elastic-system namespace)
3. Then deploy this Kibana configuration
4. Run Terraform:

```bash
terraform init
terraform plan
terraform apply
```

## Related Documentation

- [ECK Multi-namespace deployment](https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s)
- [Kubernetes Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [Kubernetes Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)