// VPC for region
resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_v4_cidr_block[0]
  assign_generated_ipv6_cidr_block = true
  tags = {
    Name    = "${var.region}.vpc-main"
    Project = var.project_name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

// Subnet in availability zone 1
resource "aws_subnet" "av_1" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.subnet_v4_cidr_blocks[0]
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 0)
  assign_ipv6_address_on_creation = true
  availability_zone               = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch         = false
  tags = {
    Name    = "${var.region}.subnet-av-1"
    Project = var.project_name
  }
}

// Subnet in availability zone 2
resource "aws_subnet" "av_2" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = var.subnet_v4_cidr_blocks[1]
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true
  availability_zone               = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch         = false
  tags = {
    Name    = "${var.region}.subnet-av-2"
    Project = var.project_name
  }
}

// Internet gateway for region
resource "aws_internet_gateway" "gw" {
  tags = {
    Name    = "${var.region}.gateway"
    Project = var.project_name
  }
}

resource "aws_internet_gateway_attachment" "gw_to_vpc" {
  internet_gateway_id = aws_internet_gateway.gw.id
  vpc_id              = aws_vpc.main.id
}

// Route table for region
resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "${var.region}.routing-table"
    Project = var.project_name
  }
}

// IPv4 route to Internet
resource "aws_route" "internet_v4" {
  destination_cidr_block = var.cidr_v4_everywhere
  gateway_id             = aws_internet_gateway.gw.id
  route_table_id         = aws_route_table.internet.id
}

// IPv6 route to Internet
resource "aws_route" "internet_v6" {
  destination_ipv6_cidr_block = var.cidr_v6_everywhere
  gateway_id                  = aws_internet_gateway.gw.id
  route_table_id              = aws_route_table.internet.id
}

// Route entry for availability zone 1
resource "aws_route_table_association" "av1_to_internet" {
  subnet_id      = aws_subnet.av_1.id
  route_table_id = aws_route_table.internet.id
}

// Route entry for availability zone 2
resource "aws_route_table_association" "av2_to_internet" {
  subnet_id      = aws_subnet.av_2.id
  route_table_id = aws_route_table.internet.id
}
