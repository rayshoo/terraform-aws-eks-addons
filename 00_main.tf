################################################################################
# EKS Addons
################################################################################

module "eks_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0"

  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn

  eks_addons = {
    aws-ebs-csi-driver = {
      addon_version            = "v1.20.0-eksbuild.1"
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
    coredns = {
      configuration_values = jsonencode({
        resources = {
          limits = {
            cpu = "0.25"
            memory = "256M"
          }
          requests = {
            cpu = "0.25"
            memory = "256M"
          }
        }
      })
    }
  }
  enable_aws_load_balancer_controller = true
  aws_load_balancer_controller = {
    set = [
      {
        name = "enableServiceMutatorWebhook"
        value = "false"
      }
    ]
  }
  enable_aws_efs_csi_driver = true
  enable_external_secrets = true
  enable_external_dns = true
  external_dns_route53_zone_arns = local.external_dns_route53_zone_arns
  external_dns = {
    set = [
      {
        name = "policy"
        value = "upsert-only"
      },
      {
        name = "domainFilters"
        value = "{${local.external_dns_domain_filters}}"
      }
    ]
  }
  external_secrets = {
    service_account_name = "${local.es_service_account_name}"
  }
  enable_cert_manager = true
  cert_manager_route53_hosted_zone_arns = local.cert_manager_route53_hosted_zone_arns

  tags = var.tags
}