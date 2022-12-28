/// Record entries with latency routing (A for Ipv4 and AAAA for Ipv6)
// IPv4 latency record
resource "aws_route53_record" "a_latency" {
  name            = var.domain_name
  type            = "A"
  zone_id         = var.aws_route53_zone_primary.zone_id
  set_identifier = "geo_load_balance-${var.region}"
  alias {
    name = aws_lb.web.dns_name
    zone_id = aws_lb.web.zone_id
    evaluate_target_health = true
  }
  latency_routing_policy {
    region = var.region
  }
}
// IPv6 latency record
resource "aws_route53_record" "aaaa_latency" {
  name            = var.domain_name
  type            = "AAAA"
  zone_id         = var.aws_route53_zone_primary.zone_id
  set_identifier = "geo_load_balance-${var.region}"
  alias {
    name = aws_lb.web.dns_name
    zone_id = aws_lb.web.zone_id
    evaluate_target_health = true
  }
  latency_routing_policy {
    region = var.region
  }
}
