module "main_region_config" {
  source                   = "./infrastructure"
  region                   = var.main_region
  cidr_v4_ssh_own_ip       = var.v4_own_ip
  cidr_v6_ssh_own_ip       = var.v6_own_ip
  aws_route53_zone_primary = aws_route53_zone.primary
  domain_name              = var.domain_name
  project_name             = var.project_name
}

module "sub_region_config" {
  source                   = "./infrastructure"
  region                   = var.sub_region
  cidr_v4_ssh_own_ip       = var.v4_own_ip
  cidr_v6_ssh_own_ip       = var.v6_own_ip
  aws_route53_zone_primary = aws_route53_zone.primary
  domain_name              = var.domain_name
  project_name             = var.project_name
}

module "third_region_config" {
  source                   = "./infrastructure"
  region                   = var.third_region
  cidr_v4_ssh_own_ip       = var.v4_own_ip
  cidr_v6_ssh_own_ip       = var.v6_own_ip
  aws_route53_zone_primary = aws_route53_zone.primary
  domain_name              = var.domain_name
  project_name             = var.project_name
}
