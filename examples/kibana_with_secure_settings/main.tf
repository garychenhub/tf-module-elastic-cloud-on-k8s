# 範例：使用 Secure Settings 的 Kibana
# 此範例展示如何配置 Kibana 並使用 Kubernetes secrets 來管理安全設定

# 創建包含 Kibana 安全設定的 Kubernetes Secret
resource "kubernetes_secret" "kibana_secure_settings" {
  metadata {
    name      = "kibana-secure-settings"
    namespace = var.namespace
  }

  type = "Opaque"

  # 使用 stringData 以避免手動進行 base64 編碼
  data = {
    # Kibana 加密密鑰 (用於加密 saved objects)
    "xpack.security.encryptionKey" = base64encode("your-32-character-encryption-key-here-123456")

    # Kibana 報告加密密鑰
    "xpack.reporting.encryptionKey" = base64encode("your-32-character-reporting-key-here-123456")

    # 其他敏感設定
    "xpack.encryptedSavedObjects.encryptionKey" = base64encode("your-32-character-saved-objects-key-here")
  }
}

# 另一個 Secret 範例：包含 SAML 設定
resource "kubernetes_secret" "kibana_saml_settings" {
  metadata {
    name      = "kibana-saml-settings"
    namespace = var.namespace
  }

  type = "Opaque"

  data = {
    # SAML 服務提供者私鑰 (範例)
    "xpack.security.authc.providers.saml.saml1.sp.private_key" = base64encode("-----BEGIN PRIVATE KEY-----\nYOUR_SAML_SP_PRIVATE_KEY_CONTENT_HERE\n-----END PRIVATE KEY-----")
  }
}

# 使用 Secure Settings 的 Kibana
module "kibana" {
  source = "../../modules/kibana"

  kibana_name     = var.kibana_name
  kibana_version  = var.kibana_version
  namespace       = var.namespace
  replicas        = var.replicas
  es_cluster_name = var.es_cluster_name
  es_namespace    = var.es_namespace  # 可選：如果 Elasticsearch 在不同的 namespace

  # 資源配置 - 使用官方建議的預設值
  resources = {
    requests = {
      memory = "1Gi"
      cpu    = "0.5"
    }
    limits = {
      memory = "2.5Gi"
      cpu    = "2"
    }
  }

  # 配置 Secure Settings
  secure_settings = [
    {
      secret_name = kubernetes_secret.kibana_secure_settings.metadata[0].name
      entries = [
        {
          key = "xpack.security.encryptionKey"
        },
        {
          key = "xpack.reporting.encryptionKey"
        },
        {
          key = "xpack.encryptedSavedObjects.encryptionKey"
        }
      ]
    },
    {
      # 引用 SAML 設定 secret
      secret_name = kubernetes_secret.kibana_saml_settings.metadata[0].name
      entries = [
        {
          key  = "xpack.security.authc.providers.saml.saml1.sp.private_key"
          path = "xpack.security.authc.providers.saml.saml1.sp.private_key"
        }
      ]
    }
  ]
}