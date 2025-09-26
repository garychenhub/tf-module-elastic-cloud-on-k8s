# Kibana Resources Configuration 範例

此範例展示如何為不同使用場景配置 Kibana 的計算資源。根據 Elastic 官方文件的建議，提供了四種不同的資源配置方案。

## 配置說明

### 1. 開發環境配置 (kibana-dev)
- **用途**: 開發、測試和學習環境
- **資源**: requests(512Mi/0.25), limits(1Gi/1)
- **特點**: 最小資源占用，適合資源受限的開發環境

### 2. 生產環境標準配置 (kibana-prod)
- **用途**: 一般生產環境
- **資源**: requests(1Gi/0.5), limits(2.5Gi/2) - 官方建議值
- **特點**: 平衡性能和資源消耗，適合大多數生產場景

### 3. 高負載環境配置 (kibana-high-load)
- **用途**: 高並發、大數據量的生產環境
- **資源**: requests(2Gi/1), limits(4Gi/4)
- **特點**: 更高的資源配置，支援更多用戶和複雜查詢

### 4. Guaranteed QoS 配置 (kibana-guaranteed)
- **用途**: 關鍵業務應用，需要穩定資源保障
- **資源**: requests 和 limits 相同 (2Gi/1)
- **特點**: Guaranteed QoS 等級，避免資源競爭導致的性能不穩定

## 資源配置建議

### 記憶體配置
- **最小配置**: 512Mi（開發環境）
- **標準配置**: 1-2.5Gi（生產環境）
- **高負載**: 2-4Gi（大型部署）

### CPU 配置
- **最小配置**: 0.25 核心（開發環境）
- **標準配置**: 0.5-2 核心（生產環境）
- **高負載**: 1-4 核心（大型部署）

### QoS 等級
- **BestEffort**: 不設定 requests 和 limits（不建議）
- **Burstable**: 設定 requests，limits 可選（一般配置）
- **Guaranteed**: requests 和 limits 相同（關鍵應用）

## 部署步驟

1. 根據您的環境需求選擇適當的配置
2. 調整變數值以符合您的需求
3. 執行部署：

```bash
terraform init
terraform plan
terraform apply
```

## 監控建議

- 使用 Kubernetes 指標監控資源使用情況
- 透過 Stack Monitoring 監控 Kibana 效能
- 根據實際使用情況調整資源配置

## 相關文件

- [ECK Compute Resources 官方文件](https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s/manage-compute-resources)
- [Kubernetes QoS Classes](https://kubernetes.io/docs/concepts/workloads/pods/pod-qos/)
- [Kubernetes Resource Management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)