# Elasticsearch with Update Strategy Example

This example demonstrates how to configure Elasticsearch cluster update strategies in Terraform to control the number of simultaneous Pod changes during updates.

## Features

- Demonstrates three different update strategy configurations
- Controls resource usage and cluster stability
- Best practices for different environments

## Update Strategy Explanation

### 1. Standard Update Strategy
Suitable for most production environments:
- `maxSurge: 3` - Allow up to 3 additional Pods to be created simultaneously
- `maxUnavailable: 2` - Allow up to 2 Pods to be unavailable simultaneously

### 2. Conservative Update Strategy
Suitable for resource-constrained or high-stability environments:
- `maxSurge: 0` - No extra Pods created, saving resources
- `maxUnavailable: 1` - Update only one Pod at a time, ensuring maximum stability

### 3. Fast Update Strategy
Suitable for development environments or scenarios requiring rapid updates:
- `maxSurge: -1` - Unlimited extra Pod creation (default behavior)
- `maxUnavailable: 2` - Allow more Pods to be unavailable simultaneously

## Use Cases

### When to use Update Strategy:

1. **大型集群**：避免同時創建過多 Pod 造成資源短缺
2. **資源受限環境**：控制資源使用，避免影響其他工作負載
3. **高可用性要求**：確保更新過程中集群始終可用
4. **節點配置變更**：在 nodeSet 配置變更時控制更新流程

### 注意事項

- **非 HA 設定**：少於 3 個節點的集群在版本升級時不會強制執行變更預算
- **複雜配置**：某些複雜場景可能需要調整 `maxSurge` 值以幫助操作器取得進展
- **資源規劃**：設定 `maxSurge` 時需考慮 Kubernetes 集群的可用資源

## 部署步驟

1. 確保您已經安裝並配置了 ECK 操作器
2. 根據您的環境選擇適當的更新策略
3. 更新變數以符合您的需求
4. 執行 Terraform 部署：

```bash
terraform init
terraform plan
terraform apply
```

## 相關文件

- [ECK Update Strategy 官方文件](https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/update-strategy)
- [Kubernetes Pod Disruption Budget](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/)
- [ECK Node Orchestration](https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/nodes-orchestration)