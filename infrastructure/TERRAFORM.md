<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.webserver_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.webserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_policy.cpu_average](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_internet_gateway.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_internet_gateway_attachment.gw_to_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway_attachment) | resource |
| [aws_key_pair.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_launch_template.webserver_machine](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.forward_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.to_webserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route.internet_v4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.internet_v6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_record.a_latency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.aaaa_latency](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route_table.internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.av1_to_internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.av2_to_internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.traffic_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.av_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.av_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [local_sensitive_file.key_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [tls_private_key.settings](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.amazonLinux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_default_cooldown"></a> [asg\_default\_cooldown](#input\_asg\_default\_cooldown) | The time before another scaling activity starts | `number` | `"120"` | no |
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | The desired auto scaling instance capacity | `number` | `"2"` | no |
| <a name="input_asg_health_check_grace_period"></a> [asg\_health\_check\_grace\_period](#input\_asg\_health\_check\_grace\_period) | The time until a health check is performed on a fresh instance | `number` | `"120"` | no |
| <a name="input_asg_maximum_capacity"></a> [asg\_maximum\_capacity](#input\_asg\_maximum\_capacity) | The maximum auto scaling instance capacity | `number` | `"5"` | no |
| <a name="input_asg_minimum_capacity"></a> [asg\_minimum\_capacity](#input\_asg\_minimum\_capacity) | The minimum auto scaling instance capacity | `number` | `"2"` | no |
| <a name="input_asg_warm_pool_max_size"></a> [asg\_warm\_pool\_max\_size](#input\_asg\_warm\_pool\_max\_size) | The maximum size of the warm pool instances for auto scaling | `number` | `"1"` | no |
| <a name="input_asg_warm_pool_min_size"></a> [asg\_warm\_pool\_min\_size](#input\_asg\_warm\_pool\_min\_size) | The minimum size of the warm pool instances for auto scaling | `number` | `"1"` | no |
| <a name="input_aws_route53_zone_primary"></a> [aws\_route53\_zone\_primary](#input\_aws\_route53\_zone\_primary) | The primary route53 hosted zone | `any` | n/a | yes |
| <a name="input_cidr_v4_everywhere"></a> [cidr\_v4\_everywhere](#input\_cidr\_v4\_everywhere) | cidr v4 block for everywhere | `string` | `"0.0.0.0/0"` | no |
| <a name="input_cidr_v4_ssh_own_ip"></a> [cidr\_v4\_ssh\_own\_ip](#input\_cidr\_v4\_ssh\_own\_ip) | own cidr v4 block for ssh access | `string` | `"127.0.0.1/32"` | no |
| <a name="input_cidr_v6_everywhere"></a> [cidr\_v6\_everywhere](#input\_cidr\_v6\_everywhere) | cidr v6 block for everywhere | `string` | `"::/0"` | no |
| <a name="input_cidr_v6_ssh_own_ip"></a> [cidr\_v6\_ssh\_own\_ip](#input\_cidr\_v6\_ssh\_own\_ip) | own cidr v6 block for ssh access | `string` | `"::1/128"` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name | `string` | `"subpair.click"` | no |
| <a name="input_instances_type"></a> [instances\_type](#input\_instances\_type) | The instances type | `string` | `"t2.micro"` | no |
| <a name="input_key_algorithm"></a> [key\_algorithm](#input\_key\_algorithm) | The key algorithm | `string` | `"RSA"` | no |
| <a name="input_key_bit_size"></a> [key\_bit\_size](#input\_key\_bit\_size) | The key bit size | `number` | `2048` | no |
| <a name="input_key_file_name"></a> [key\_file\_name](#input\_key\_file\_name) | The key name | `string` | `"sshKey.pem"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The key name | `string` | `"sshKey"` | no |
| <a name="input_region"></a> [region](#input\_region) | The main region | `string` | `"eu-central-1"` | no |
| <a name="input_subnet_v4_cidr_blocks"></a> [subnet\_v4\_cidr\_blocks](#input\_subnet\_v4\_cidr\_blocks) | Available v4 cidr blocks for public subnets. | `list(string)` | <pre>[<br>  "10.0.0.0/17",<br>  "10.0.128.0/17"<br>]</pre> | no |
| <a name="input_vpc_v4_cidr_block"></a> [vpc\_v4\_cidr\_block](#input\_vpc\_v4\_cidr\_block) | Available v4 cidr blocks for public subnets. | `list(string)` | <pre>[<br>  "10.0.0.0/16"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_load_balancer"></a> [load\_balancer](#output\_load\_balancer) | n/a |
<!-- END_TF_DOCS -->