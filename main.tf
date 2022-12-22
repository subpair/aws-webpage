module "main_region_config" {
  source = "./infrastructure"
  region = var.main_region
}
module "sub_region_config" {
  source = "./infrastructure"
  region = var.sub_region
}
/// Route53
// Hosted record zone
resource "aws_route53_zone" "primary" {
  name = var.domain_name
  tags = {
    Name = "hosted-zone_primary"
  }
}
// Record entries with latency routing (A for Ipv4 and AAAA for Ipv6)
resource "aws_route53_record" "a_main_region_record" {
  name            = var.domain_name
  type            = "A"
  zone_id         = aws_route53_zone.primary.zone_id
  set_identifier = "geo_load_balance-${var.main_region}"
  alias {
    name = module.main_region_config.load_balancer.dns_name
    zone_id = module.main_region_config.load_balancer.zone_id
    evaluate_target_health = true
  }
  latency_routing_policy {
    region = var.main_region
  }
}
resource "aws_route53_record" "a_sub_region_record" {
  name            = var.domain_name
  type            = "A"
  zone_id         = aws_route53_zone.primary.zone_id
  set_identifier = "geo_load_balance-${var.sub_region}"
  alias {
    name = module.sub_region_config.load_balancer.dns_name
    zone_id = module.sub_region_config.load_balancer.zone_id
    evaluate_target_health = true
  }
  latency_routing_policy {
    region = var.sub_region
  }
}
resource "aws_route53_record" "aaaa_main_region_record" {
  name            = var.domain_name
  type            = "AAAA"
  zone_id         = aws_route53_zone.primary.zone_id
  set_identifier = "geo_load_balance-${var.main_region}"
  alias {
    name = module.main_region_config.load_balancer.dns_name
    zone_id = module.main_region_config.load_balancer.zone_id
    evaluate_target_health = true
  }
  latency_routing_policy {
    region = var.main_region
  }
}
resource "aws_route53_record" "aaaa_sub_region_record" {
  name            = var.domain_name
  type            = "AAAA"
  zone_id         = aws_route53_zone.primary.zone_id
  set_identifier = "geo_load_balance-${var.sub_region}"
  alias {
    name = module.sub_region_config.load_balancer.dns_name
    zone_id = module.sub_region_config.load_balancer.zone_id
    evaluate_target_health = true
  }
  latency_routing_policy {
    region = var.sub_region
  }
}
// Update the domains name servers
resource "aws_route53domains_registered_domain" "set_name_servers" {
  domain_name = var.domain_name
  name_server {
    name = aws_route53_zone.primary.name_servers[0]
  }
  name_server {
    name = aws_route53_zone.primary.name_servers[1]
  }
  name_server {
    name = aws_route53_zone.primary.name_servers[2]
  }
  name_server {
    name = aws_route53_zone.primary.name_servers[3]
  }
  tags = {
    Name = "domain-nameservers"
  }
}
