// Key settings
resource "tls_private_key" "settings" {
  algorithm = var.key_algorithm
  rsa_bits  = var.key_bit_size
}
// Key pair settings
resource "aws_key_pair" "main" {
  key_name   = var.key_name
  public_key = tls_private_key.settings.public_key_openssh
  tags = {
    Name = "settings"
  }
}
// Key output
resource "local_sensitive_file" "key_file" {
  content  = tls_private_key.settings.private_key_pem
  filename = "${var.region}_${var.key_file_name}"
  file_permission = "600"
  directory_permission = "700"
}
// Security group with inbound and outbound rules
resource "aws_security_group" "traffic_rules" {
  name        = "traffic-rules"
  description = "allow ssh-http-yum traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    description      = "ssh inbound"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_v4_ssh_own_ip]
    ipv6_cidr_blocks = [var.cidr_v6_ssh_own_ip]
  }
    ingress {
    description      = "http inbound"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_v4_everywhere]
    ipv6_cidr_blocks = [var.cidr_v6_everywhere]
  }
  egress {
    description      = "ssh outbound"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_v4_everywhere]
    ipv6_cidr_blocks = [var.cidr_v6_everywhere]
  }
  egress {
    description      = "http outbound"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_v4_everywhere]
    ipv6_cidr_blocks = [var.cidr_v6_everywhere]
  }
    egress {
    description      = "https outbound"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_v4_everywhere]
    ipv6_cidr_blocks = [var.cidr_v6_everywhere]
  }
  tags = {
    Name = "security-group-traffic-rules"
  }
}
