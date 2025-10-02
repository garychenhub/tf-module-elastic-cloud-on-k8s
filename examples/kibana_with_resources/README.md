# Kibana Resources Configuration Example

This example demonstrates how to configure Kibana compute resources for different use cases. Based on Elastic's official documentation recommendations, four different resource configuration scenarios are provided.

## Configuration Overview

### 1. Development Environment Configuration (kibana-dev)
- **Purpose**: Development, testing, and learning environments
- **Resources**: requests(512Mi/0.25), limits(1Gi/1)
- **Features**: Minimal resource usage, suitable for resource-constrained development environments

### 2. Production Standard Configuration (kibana-prod)
- **Purpose**: General production environments
- **Resources**: requests(1Gi/0.5), limits(2.5Gi/2) - Official recommended values
- **Features**: Balanced performance and resource consumption, suitable for most production scenarios

### 3. High-Load Environment Configuration (kibana-high-load)
- **Purpose**: High-concurrency, large-data production environments
- **Resources**: requests(2Gi/1), limits(4Gi/4)
- **Features**: Higher resource allocation, supporting more users and complex queries

### 4. Guaranteed QoS Configuration (kibana-guaranteed)
- **Purpose**: Critical business applications requiring stable resource guarantees
- **Resources**: requests and limits are identical (2Gi/1)
- **Features**: Guaranteed QoS class, avoiding performance instability from resource competition

## Resource Configuration Recommendations

### Memory Configuration
- **Minimal**: 512Mi (development environment)
- **Standard**: 1-2.5Gi (production environment)
- **High-load**: 2-4Gi (large deployments)

### CPU Configuration
- **Minimal**: 0.25 cores (development environment)
- **Standard**: 0.5-2 cores (production environment)
- **High-load**: 1-4 cores (large deployments)

### QoS Classes
- **BestEffort**: No requests and limits set (not recommended)
- **Burstable**: Set requests, limits optional (general configuration)
- **Guaranteed**: requests and limits identical (critical applications)

## Deployment Steps

1. Choose the appropriate configuration based on your environment requirements
2. Adjust variable values to meet your needs
3. Execute deployment:

```bash
terraform init
terraform plan
terraform apply
```

## Monitoring Recommendations

- Use Kubernetes metrics to monitor resource usage
- Monitor Kibana performance through Stack Monitoring
- Adjust resource configurations based on actual usage patterns

## Related Documentation

- [ECK Compute Resources Official Documentation](https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/manage-compute-resources)
- [Kubernetes QoS Classes](https://kubernetes.io/docs/concepts/workloads/pods/pod-qos/)
- [Kubernetes Resource Management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)