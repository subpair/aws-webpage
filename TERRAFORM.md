<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_main_region_config"></a> [main\_region\_config](#module\_main\_region\_config) | ./infrastructure | n/a |
| <a name="module_sub_region_config"></a> [sub\_region\_config](#module\_sub\_region\_config) | ./infrastructure | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53domains_registered_domain.set_name_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53domains_registered_domain) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name | `string` | `"subpair.click"` | no |
| <a name="input_load_balancer_deletion_protection"></a> [load\_balancer\_deletion\_protection](#input\_load\_balancer\_deletion\_protection) | Activate the load balancer deletion protection to avoid downtimes on terraform configuration updates | `bool` | `false` | no |
| <a name="input_main_region"></a> [main\_region](#input\_main\_region) | The main region | `string` | `"eu-central-1"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The project's name | `string` | `"simple-webpage"` | no |
| <a name="input_sub_region"></a> [sub\_region](#input\_sub\_region) | The sub region | `string` | `"us-west-1"` | no |
| <a name="input_target_port"></a> [target\_port](#input\_target\_port) | The application's target port | `number` | `80` | no |
| <a name="input_third_region"></a> [third\_region](#input\_third\_region) | The third region | `string` | `"ap-northeast-1"` | no |
| <a name="input_v4_own_ip"></a> [v4\_own\_ip](#input\_v4\_own\_ip) | v4 ip address for ssh access | `string` | `"87.166.106.16/32"` | no |
| <a name="input_v6_own_ip"></a> [v6\_own\_ip](#input\_v6\_own\_ip) | v6 ip address for ssh access | `string` | `"2003:F8:4712:D584:F488:FEFC:FCFD:C/128"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->