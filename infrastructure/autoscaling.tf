// Amazon machine image - current available amazon linux
data "aws_ami" "amazonLinux" {
  most_recent = true
  owners      = ["amazon"]

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
    name   = "state"
    values = ["available"]
  }
}

// Launch template for webserver
resource "aws_launch_template" "webserver_machine" {
  name          = "webserver-machine-template"
  image_id      = data.aws_ami.amazonLinux.image_id
  instance_type = var.instances_type
  key_name      = aws_key_pair.main.key_name
  user_data     = filebase64("${path.module}/start_script.sh")

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.traffic_rules.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "${var.region}.webserver"
      Project = "simple-webpage"
    }
  }
}

// Auto scaling group
resource "aws_autoscaling_group" "webserver" {
  name                      = "webserver-asg"
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
      reuse_on_scale_in = false
    }
  }

  launch_template {
    id      = aws_launch_template.webserver_machine.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.region}.webserver-asg"
    propagate_at_launch = true
  }
}

// Autoscaling group policy to scale up when CPU average utilization of >80 is reached
resource "aws_autoscaling_policy" "cpu_average" {
  autoscaling_group_name = aws_autoscaling_group.webserver.name
  name                   = "cpu-scaling"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}
