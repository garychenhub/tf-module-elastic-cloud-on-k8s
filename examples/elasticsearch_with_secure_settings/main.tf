# 範例：使用 Secure Settings 的 Elasticsearch 集群
# 此範例展示如何配置 Elasticsearch 集群並使用 Kubernetes secrets 來管理安全設定

# 創建包含安全設定的 Kubernetes Secret
resource "kubernetes_secret" "elasticsearch_secure_settings" {
  metadata {
    name      = "elasticsearch-secure-settings"
    namespace = var.namespace
  }

  type = "Opaque"

  data = {
    # GCS 快照存儲庫的服務帳戶金鑰
    "gcs.client.default.credentials_file" = base64encode(jsonencode({
      "type"                        = "service_account"
      "project_id"                  = "your-project-id"
      "private_key_id"              = "your-private-key-id"
      "private_key"                 = "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
      "client_email"                = "your-service-account@your-project-id.iam.gserviceaccount.com"
      "client_id"                   = "your-client-id"
      "auth_uri"                    = "https://accounts.google.com/o/oauth2/auth"
      "token_uri"                   = "https://accounts.google.com/o/oauth2/token"
      "auth_provider_x509_cert_url" = "https://www.googleapis.com/oauth2/v1/certs"
      "client_x509_cert_url"        = "https://www.googleapis.com/robot/v1/metadata/x509/your-service-account@your-project-id.iam.gserviceaccount.com"
    }))

    # LDAP 綁定密碼
    "xpack.security.authc.realms.ldap.ldap1.bind_password" = base64encode("your-ldap-bind-password")
  }
}

# 使用字符串數據的另一個 Secret 範例
resource "kubernetes_secret" "elasticsearch_string_settings" {
  metadata {
    name      = "elasticsearch-string-settings"
    namespace = var.namespace
  }

  type = "Opaque"

  # 使用 stringData 以避免手動進行 base64 編碼
  data = {
    "xpack.security.encryptionKey" = base64encode("your-32-character-encryption-key-here")
  }
}

# 使用 Secure Settings 的 Elasticsearch 集群
module "elasticsearch_cluster" {
  source = "../../modules/elasticsearch_cluster"

  es_cluster_name = var.es_cluster_name
  es_version      = var.es_version
  namespace       = var.namespace

  global_config = {
    "node.store.allow_mmap"  = false
    "xpack.security.enabled" = true
  }

  node_sets = [
    {
      name  = "master"
      count = 3
      config = {
        "node.roles" = "[\"master\"]"
      }
      resources = {
        requests = {
          memory = "2Gi"
          cpu    = "1"
        }
        limits = {
          memory = "4Gi"
          cpu    = "2"
        }
      }
      storage = {
        size          = "10Gi"
        storage_class = "fast-ssd"
      }
    },
    {
      name  = "data"
      count = 2
      config = {
        "node.roles" = "[\"data\", \"ingest\"]"
      }
      resources = {
        requests = {
          memory = "4Gi"
          cpu    = "2"
        }
        limits = {
          memory = "8Gi"
          cpu    = "4"
        }
      }
      storage = {
        size          = "100Gi"
        storage_class = "fast-ssd"
      }
    }
  ]

  # 配置 Secure Settings
  secure_settings = [
    {
      secret_name = kubernetes_secret.elasticsearch_secure_settings.metadata[0].name
      entries = [
        {
          key = "gcs.client.default.credentials_file"
        },
        {
          key  = "xpack.security.authc.realms.ldap.ldap1.bind_password"
          path = "xpack.security.authc.realms.ldap.ldap1.bind_password"
        }
      ]
    },
    {
      # 引用整個 secret，不指定特定條目
      secret_name = kubernetes_secret.elasticsearch_string_settings.metadata[0].name
    }
  ]
}