module "main_region_config" {
  source                            = "./infrastructure"
  project_name                      = var.project_name
  region                            = var.main_region
  cidr_v4_ssh_own_ip                = var.v4_own_ip
  cidr_v6_ssh_own_ip                = var.v6_own_ip
  domain_name                       = var.domain_name
  load_balancer_deletion_protection = var.load_balancer_deletion_protection
  aws_route53_zone_primary          = aws_route53_zone.primary
  target_port                       = var.target_port
}

module "sub_region_config" {
  source                            = "./infrastructure"
  project_name                      = var.project_name
  region                            = var.sub_region
  cidr_v4_ssh_own_ip                = var.v4_own_ip
  cidr_v6_ssh_own_ip                = var.v6_own_ip
  domain_name                       = var.domain_name
  load_balancer_deletion_protection = var.load_balancer_deletion_protection
  aws_route53_zone_primary          = aws_route53_zone.primary
  target_port                       = var.target_port
}

//module "third_region_config" {
//  project_name                      = var.project_name
//  source                            = "./infrastructure"
//  region                            = var.third_region
//  cidr_v4_ssh_own_ip                = var.v4_own_ip
//  cidr_v6_ssh_own_ip                = var.v6_own_ip
//  domain_name                       = var.domain_name
//  load_balancer_deletion_protection = var.load_balancer_deletion_protection
//  aws_route53_zone_primary          = aws_route53_zone.primary
//  target_port                       = var.target_port
//}
