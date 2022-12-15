// >
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block[0]
}
// AV1
resource "aws_subnet" "main-av1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_blocks[0]
  availability_zone = var.subnet-availability_zone[0]
  map_public_ip_on_launch = true
}
// AV2
resource "aws_subnet" "main-av2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_blocks[1]
  availability_zone = var.subnet-availability_zone[1]
  map_public_ip_on_launch = true
}
// >
resource "aws_internet_gateway" "gw" {
  }
  resource "aws_internet_gateway_attachment" "example" {
    internet_gateway_id = aws_internet_gateway.gw.id
    vpc_id              = aws_vpc.main.id
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.cidr_everywhere
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table_association" "av-1" {
  subnet_id      = aws_subnet.main-av1.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "av-2" {
  subnet_id      = aws_subnet.main-av2.id
  route_table_id = aws_route_table.rt.id
}
resource "tls_private_key" "pk" {
  algorithm = var.key_algorithm
  rsa_bits  = var.key_bit_size
}
resource "aws_key_pair" "kp" {
  key_name   = var.key_name
  public_key = tls_private_key.pk.public_key_openssh
}
resource "local_sensitive_file" "key_file" {
    content  = tls_private_key.pk.private_key_pem
    filename = var.key_file_name
    file_permission = "600"
    directory_permission = "700"
}
resource "aws_security_group" "allow_traffic" {
  name        = "allow_traffic"
  description = "Allow ssh and http inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "ssh from outside"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_everywhere]
  }
    ingress {
    description      = "http from outside"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_everywhere]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.cidr_everywhere]
    ipv6_cidr_blocks = ["::/0"]
  }
}
resource "aws_launch_template" "webserver" {
  name = "webserver"
  image_id = var.ami
  instance_type = var.instances_type
  network_interfaces {
    device_index = 0
    associate_public_ip_address = true
    delete_on_termination = true
    security_groups = [aws_security_group.allow_traffic.id]
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "WebServerASG"
    }
  }
  user_data = filebase64("${path.module}/start_script.sh")
}
resource "aws_lb" "web-load-balancer" {
  name               = "web-load-balancer"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_traffic.id]
  subnets            = [aws_subnet.main-av1.id,aws_subnet.main-av2.id]

}
resource "aws_lb_target_group" "webtraffic" {
  name     = "web-traffic"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  ip_address_type = "ipv4"
}
resource "aws_autoscaling_group" "webserver-asg" {
  name = "WebServerASG"
  vpc_zone_identifier = [aws_subnet.main-av1.id,aws_subnet.main-av2.id]
  desired_capacity   = var.asg_desired_capacity
  max_size           = var.asg_maximum_capacity
  min_size           = var.asg_minimum_capacity
  launch_template {
    id      = aws_launch_template.webserver.id
    version = "$Latest"
  }
}
resource "aws_autoscaling_attachment" "lb-asg" {
  autoscaling_group_name = aws_autoscaling_group.webserver-asg.id
  lb_target_group_arn    = aws_lb_target_group.webtraffic.arn
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webtraffic.arn
  }
}
