resource "aws_route53_zone" "primary" {
  name = var.domain_name
}
resource "aws_route53_traffic_policy" "geoloadbalancing" {
  name     = "geobalancing-policy"
  comment  = "balance on latency"
  document = <<EOF
{
  "AWSPolicyFormatVersion":"2015-10-01",
  "RecordType":"A",
  "StartRule":"region_selector",
  "Endpoints":{
    "central_lb":{
      "Type":"elastic-load-balancer",
      "Value":"web-load-balancer-396603102.eu-central-1.elb.amazonaws.com"
    },
    "west_lb":{
      "Type":"elastic-load-balancer",
      "Value":"web-load-balancer-1253202082.eu-west-3.elb.amazonaws.com"
    }
  },
  "Rules":{
    "region_selector":{
      "RuleType":"latency",
      "Regions":[
        {
          "Region":"eu-central-1",
          "EndpointReference":"central_lb"
        },
        {
          "Region":"eu-west-3",
          "EndpointReference":"west_lb"
        }
      ]
    }
  }
}
EOF
}
resource "aws_route53_traffic_policy_instance" "geobalancing-instance" {
  name                   = "subpair.click"
  traffic_policy_id      = aws_route53_traffic_policy.geoloadbalancing.id
  traffic_policy_version = 1
  hosted_zone_id         = aws_route53_zone.primary.id
  ttl                    = 60
}
resource "aws_route53_traffic_policy_instance" "geobalancing-instance-www" {
  name                   = "www.subpair.click"
  traffic_policy_id      = aws_route53_traffic_policy.geoloadbalancing.id
  traffic_policy_version = 1
  hosted_zone_id         = aws_route53_zone.primary.id
  ttl                    = 60
}
resource "aws_route53domains_registered_domain" "domain" {
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
}
