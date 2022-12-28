// Load balancer
resource "aws_lb" "web" {
  name               = "web-load-balancer"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.traffic_rules.id]
  subnets            = [aws_subnet.av_1.id,aws_subnet.av_2.id]
  ip_address_type = "dualstack"
  tags = {
    Name = "${var.region}.loadbalancer"
  }
  drop_invalid_header_fields = true
}
// Load balancer target group for HTTP traffic
resource "aws_lb_target_group" "to_webserver" {
  name     = "webtraffic"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  tags = {
    Name = "${var.region}.loadbalancer_target-group"
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
    Name = "${var.region}.lb_listener"
  }
}
// Load balancer attachment to auto scaling group
resource "aws_autoscaling_attachment" "webserver_balancer" {
  autoscaling_group_name = aws_autoscaling_group.webserver.id
  lb_target_group_arn    = aws_lb_target_group.to_webserver.arn
}
