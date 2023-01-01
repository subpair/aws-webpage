// Output the load_balancer to use it as endpoint for Route53
output "load_balancer" {
  value = aws_lb.web
}
