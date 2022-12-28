// Hosted record zone
resource "aws_route53_zone" "primary" {
  name = var.domain_name
  tags = {
    Name = "hosted-zone_primary"
  }
}
// Update the domain's name servers
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
