# Elasticsearch with Secure Settings 範例

此範例展示如何在 Terraform 中使用 ECK (Elastic Cloud on Kubernetes) 操作器部署具有安全設定的 Elasticsearch 集群。

## 功能特色

- 使用 Kubernetes Secrets 管理敏感設定
- 支援多種安全設定類型（GCS 憑證、LDAP 密碼、加密密鑰等）
- 展示兩種不同的 Secret 引用方式：
  - 指定特定條目並可選擇自定義路徑
  - 引用整個 Secret 的所有條目

## 使用的安全設定

### 1. GCS 快照存儲庫憑證
配置 Google Cloud Storage 作為 Elasticsearch 快照存儲庫的服務帳戶憑證。

### 2. LDAP 認證
配置 LDAP 認證所需的綁定密碼。

### 3. 加密密鑰
配置 Elasticsearch 安全功能所需的加密密鑰。

## 部署步驟

1. 確保您已經安裝並配置了 ECK 操作器
2. 更新變數以符合您的環境需求
3. 執行 Terraform 部署：

```bash
terraform init
terraform plan
terraform apply
```

## 重要注意事項

- 確保您的 Kubernetes 集群已經安裝了 ECK 操作器
- 替換範例中的佔位符值（如 project-id、私鑰等）為實際值
- 妥善保護包含敏感資訊的 Terraform 狀態檔案
- 考慮使用 Terraform 的 sensitive 屬性來標記敏感變數

## 相關文件

- [ECK Secure Settings 官方文件](https://www.elastic.co/docs/deploy-manage/security/k8s-secure-settings)
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Elasticsearch Keystore](https://www.elastic.co/docs/elasticsearch/reference/current/secure-settings.html)