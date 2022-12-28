// VPC for region
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_v4_cidr_block[0]
  assign_generated_ipv6_cidr_block = true
  tags = {
    Name = "${var.region}.vpc-main"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}

// Subnet in availability zone 1
resource "aws_subnet" "av_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_v4_cidr_blocks[0]
  ipv6_cidr_block = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 0)
  assign_ipv6_address_on_creation = true
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.region}.subnet-av_1"
  }
}
// Subnet in availability zone 2
resource "aws_subnet" "av_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_v4_cidr_blocks[1]
  ipv6_cidr_block = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.region}.subnet-av_2"
  }
}
// Internet gateway for region
resource "aws_internet_gateway" "gw" {
  tags = {
    Name = "${var.region}.gateway"
  }
}
  resource "aws_internet_gateway_attachment" "gw_to_vpc" {
    internet_gateway_id = aws_internet_gateway.gw.id
    vpc_id              = aws_vpc.main.id
}
// Route table for region
resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.cidr_v4_everywhere
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    ipv6_cidr_block = var.cidr_v6_everywhere
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.region}.routing-table"
  }
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
// Key settings
resource "tls_private_key" "pk_settings" {
  algorithm = var.key_algorithm
  rsa_bits  = var.key_bit_size
}
// Key pair settings
resource "aws_key_pair" "kp_settings" {
  key_name   = "${var.region}.${var.key_name}"
  public_key = tls_private_key.pk_settings.public_key_openssh
  tags = {
    Name = "${var.region}.kp_settings"
  }
}
// Key output
resource "local_sensitive_file" "key_file" {
  content  = tls_private_key.pk_settings.private_key_pem
  filename = "${var.region}.${var.key_file_name}"
  file_permission = "600"
  directory_permission = "700"
}
// Security group with inbound and outbound rules
resource "aws_security_group" "traffic_rules" {
  name        = "${var.region}.traffic rules"
  description = "allow ssh/http/yum traffic"
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
    Name = "${var.region}.securitygroup-traffic_rules"
  }
}
data "aws_ami" "amazonLinux" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "state"
    values = ["available"]
  }
}
// Launch template for webserver
resource "aws_launch_template" "webserver_machine" {
  name = "${var.region}.webserver_machine"
  image_id = data.aws_ami.amazonLinux.image_id
  instance_type = var.instances_type
  key_name = "${var.region}.${var.key_name}"
  network_interfaces {
    device_index = 0
    associate_public_ip_address = true
    delete_on_termination = true
    security_groups = [aws_security_group.traffic_rules.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.region}.webserver"
    }
  }
  user_data = filebase64("${path.module}/start_script.sh")
}
// Load balancer
resource "aws_lb" "web_balancer" {
  name               = "web-load-balancer"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.traffic_rules.id]
  subnets            = [aws_subnet.av_1.id,aws_subnet.av_2.id]
  ip_address_type = "dualstack"
  tags = {
    Name = "${var.region}.loadbalancer"
  }
}
// Load balancer target group for HTTP traffic
resource "aws_lb_target_group" "lb_to_web_targets" {
  name     = "webtraffic"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "${var.region}.loadbalancer_target-group"
  }
}
// Auto scaling group
resource "aws_autoscaling_group" "scaling_webserver" {
  name                      = "${var.region}.webserver_asg"
  vpc_zone_identifier       = [aws_subnet.av_1.id, aws_subnet.av_2.id]
  desired_capacity          = var.asg_desired_capacity
  max_size                  = var.asg_maximum_capacity
  min_size                  = var.asg_minimum_capacity
  default_cooldown          = var.asg_default_cooldown
  health_check_grace_period = var.asg_health_check_grace_period
  warm_pool {
    pool_state                  = "Running"
    min_size                    = var.asg_warm_pool_min_size
    max_group_prepared_capacity = var.asg_warm_pool_max_size
    instance_reuse_policy {
      reuse_on_scale_in = true
    }
  }
  launch_template {
    id      = aws_launch_template.webserver_machine.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "cpu_average" {
  autoscaling_group_name = aws_autoscaling_group.scaling_webserver.name
  name                   = "cpu-scaling"
  adjustment_type        = "ChangeInCapacity"
  policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}

// Load balancer attachment to auto scaling group
resource "aws_autoscaling_attachment" "scaling_webserver_balancer" {
  autoscaling_group_name = aws_autoscaling_group.scaling_webserver.id
  lb_target_group_arn    = aws_lb_target_group.lb_to_web_targets.arn
}
// Load balancer listener for HTTP traffic
resource "aws_lb_listener" "lb_to_scaling_webserver" {
  load_balancer_arn = aws_lb.web_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_to_web_targets.arn
  }
  tags = {
    Name = "${var.region}.lb_listener"
  }
}
output "load_balancer" {
  value = aws_lb.web_balancer
}
