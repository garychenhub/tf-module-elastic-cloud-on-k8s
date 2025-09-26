# Kibana Cross-Namespace 範例

此範例展示如何在不同的 Kubernetes namespace 中部署 Kibana 和 Elasticsearch，這在多租戶環境或需要邏輯分離的場景中很有用。

## 使用情況

當您需要在以下情況下使用跨 namespace 配置：

1. **多租戶環境**：不同團隊或應用使用不同的 namespace
2. **邏輯分離**：將搜索後端（Elasticsearch）和前端（Kibana）分離
3. **權限控制**：不同 namespace 有不同的 RBAC 權限
4. **資源隔離**：更好的資源配額和限制管理

## 配置說明

在此範例中：
- Kibana 部署在 `kibana-system` namespace
- Elasticsearch 集群在 `elastic-system` namespace
- 通過 `es_namespace` 參數指定跨 namespace 引用

## 重要注意事項

1. **服務發現**：ECK 操作器會自動處理跨 namespace 的服務發現
2. **網路政策**：確保 namespace 之間的網路連通性
3. **RBAC 權限**：確保 Kibana 有權訪問 Elasticsearch namespace 中的服務
4. **TLS 證書**：ECK 會自動處理跨 namespace 的 TLS 通信

## 部署步驟

1. 確保兩個 namespace 都已創建：
```bash
kubectl create namespace kibana-system
kubectl create namespace elastic-system
```

2. 首先部署 Elasticsearch 集群（在 elastic-system namespace）
3. 然後部署此 Kibana 配置
4. 執行 Terraform：

```bash
terraform init
terraform plan
terraform apply
```

## 相關文件

- [ECK Multi-namespace deployment](https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s)
- [Kubernetes Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
- [Kubernetes Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)