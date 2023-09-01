# terraform aws eks addons
To install karpenter addons with deployment kind addons. Install this after install [rayshoo/eks-init/aws](github.com/rayshoo/terraform-aws-eks-init) module.

## Example
```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.31.2"
  ...
}

module "eks_init" {
  source  = "rayshoo/eks-init/aws"
  version = "1.0.0"
  ...
}

module "eks_addons" {
  source  = "rayshoo/eks-addons/aws"
  version = "1.0.0"

  region                = var.region
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnets
  eks_private_cidr      = local.eks_private_cidr

  cluster_name          = module.eks.cluster_name
  cluster_endpoint      = module.eks.cluster_endpoint
  cluster_version       = module.eks.cluster_version
  oidc_provider_arn     = module.eks.oidc_provider_arn
  oidc_provider         = module.eks.oidc_provider

  external_dns_zones    = ["example.com", "example.co.kr"]
  cert_manage_zones     = ["example.com", "example.co.kr"]
  acme_email            = "noreply@example.com"

  cluster_ca_certificate = module.eks.cluster_certificate_authority_data

  tags = local.tags
}

```