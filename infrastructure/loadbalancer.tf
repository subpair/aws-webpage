// Load balancer
resource "aws_lb" "web" {
  name                       = "web-load-balancer"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.traffic_rules_load_balancer.id]
  subnets                    = [aws_subnet.av_1.id, aws_subnet.av_2.id]
  ip_address_type            = "dualstack"
  drop_invalid_header_fields = true
  enable_deletion_protection = var.load_balancer_deletion_protection
  tags = {
    Name    = "${var.region}.load-balancer"
    Project = var.project_name
  }
}

// Load balancer target group for HTTP traffic
resource "aws_lb_target_group" "to_webserver" {
  name     = "webtraffic"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    enabled  = true
    port     = 80
    protocol = "HTTP"
    path     = "/index.html"
    timeout  = 5
    interval = 10
  }
  tags = {
    Name    = "${var.region}.load-balancer-target-group"
    Project = var.project_name
  }
}

// Load balancer listener for HTTP traffic
resource "aws_lb_listener" "forward_http" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.to_webserver.arn
  }

  tags = {
    Name    = "${var.region}.lb-listener"
    Project = var.project_name
  }
}

// Load balancer attachment to auto scaling group
resource "aws_autoscaling_attachment" "webserver_balancer" {
  autoscaling_group_name = aws_autoscaling_group.webserver.id
  lb_target_group_arn    = aws_lb_target_group.to_webserver.arn
}
