# Kibana with Secure Settings 範例

此範例展示如何在 Terraform 中使用 ECK (Elastic Cloud on Kubernetes) 操作器部署具有安全設定的 Kibana。

## 功能特色

- 使用 Kubernetes Secrets 管理 Kibana 敏感設定
- 支援多種 Kibana 安全設定類型
- 展示兩種不同的 Secret 引用方式：
  - 指定特定條目並可選擇自定義路徑
  - 引用整個 Secret 的所有條目

## 使用的安全設定

### 1. 加密密鑰設定

配置 Kibana 所需的各種加密密鑰：

- `xpack.security.encryptionKey` - 用於加密安全相關資料
- `xpack.reporting.encryptionKey` - 用於加密報告功能
- `xpack.encryptedSavedObjects.encryptionKey` - 用於加密儲存的物件

### 2. SAML 認證設定

配置 SAML 單一登入所需的私鑰。

## 部署步驟

1. 確保您已經安裝並配置了 ECK 操作器
2. 確保已經部署了 Elasticsearch 集群
3. 更新變數以符合您的環境需求
4. 執行 Terraform 部署：

```bash
terraform init
terraform plan
terraform apply
```

## 重要注意事項

- 確保您的 Kubernetes 集群已經安裝了 ECK 操作器
- 替換範例中的佔位符值（如加密密鑰、私鑰等）為實際值
- 加密密鑰應該是 32 字元長度的隨機字串
- 妥善保護包含敏感資訊的 Terraform 狀態檔案
- 確保引用的 Elasticsearch 集群名稱正確

## 相關文件

- [ECK Secure Settings 官方文件](https://www.elastic.co/docs/deploy-manage/security/k8s-secure-settings)
- [Kibana Security Settings](https://www.elastic.co/docs/kibana/current/secure-settings.html)
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)