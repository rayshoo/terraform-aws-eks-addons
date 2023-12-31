################################################################################
# External-Secrets
################################################################################

locals {
  es_service_account_name = "external-secrets-sa"
}

resource "kubectl_manifest" "cluster_secretstore" {
  yaml_body  = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: default
spec:
  provider:
    aws:
      service: SecretsManager
      region: ${var.region}
      auth:
        jwt:
          serviceAccountRef:
            name: ${local.es_service_account_name}
            namespace: external-secrets
YAML

  depends_on = [
    module.eks_addons
  ]
}