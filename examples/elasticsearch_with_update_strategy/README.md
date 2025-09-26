# Elasticsearch with Update Strategy 範例

此範例展示如何在 Terraform 中配置 Elasticsearch 集群的更新策略，以控制 Pod 在更新過程中的同時變更數量。

## 功能特色

- 展示三種不同的更新策略配置
- 控制資源使用和集群穩定性
- 適用於不同環境的最佳實踐

## 更新策略說明

### 1. 標準更新策略
適用於大多數生產環境：
- `maxSurge: 3` - 最多同時創建 3 個額外 Pod
- `maxUnavailable: 2` - 最多同時有 2 個 Pod 不可用

### 2. 保守更新策略
適用於資源受限或高穩定性要求的環境：
- `maxSurge: 0` - 不創建額外 Pod，節省資源
- `maxUnavailable: 1` - 一次只更新一個 Pod，確保最大穩定性

### 3. 快速更新策略
適用於開發環境或需要快速更新的場景：
- `maxSurge: -1` - 無限制創建額外 Pod（默認行為）
- `maxUnavailable: 2` - 允許更多 Pod 同時不可用

## 使用場景

### 適用於使用 Update Strategy 的情況：

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