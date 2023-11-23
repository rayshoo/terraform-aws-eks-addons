################################################################################
# External-DNS
################################################################################

locals {
  external_dns_zones = flatten([
    for zone in var.external_dns_zones : flatten([
      zone.hosting == true ? [zone.name] : []
    ])
  ])
  external_dns_route53_zone_arns = data.aws_route53_zone.external_dns[*].arn
  external_dns_domain_filters = "${join(",", [for s in local.external_dns_zones : format("%s", s)])}"
}

data "aws_route53_zone" "external_dns" {
  count = length(local.external_dns_zones)
  name = element(local.external_dns_zones, count.index)
}