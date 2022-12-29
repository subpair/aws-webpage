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
| <a name="input_main_region"></a> [main\_region](#input\_main\_region) | The main region | `string` | `"eu-central-1"` | no |
| <a name="input_sub_region"></a> [sub\_region](#input\_sub\_region) | The sub region | `string` | `"eu-west-3"` | no |
| <a name="input_third_region"></a> [third\_region](#input\_third\_region) | The third region | `string` | `"us-east-1"` | no |
| <a name="input_v4_own_ip"></a> [v4\_own\_ip](#input\_v4\_own\_ip) | v4 ip address for ssh access | `string` | `"87.166.101.116/32"` | no |
| <a name="input_v6_own_ip"></a> [v6\_own\_ip](#input\_v6\_own\_ip) | v6 ip address for ssh access | `string` | `"2003:F8:4715:E0D:7934:1299:2D9C:B207/128"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->