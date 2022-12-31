# A scalable and high-available simple webpage on AWS

This repository contains infrastructure-as-code for a highly available and scalable simple webpage on AWS. \
It was written for the IU University's course *"DLBSEPCP01_E - Cloud Programming"*. \
This code was written for Terraform v1.3.5.

# Contains

This configuration contains:
- Auto-scaling and load balanced Ec2 infrastructure with a minimal webserver deployment (preconfigured for two regions)
- Route53 latency routing to the load balanced regions
- Modular build to easily scale the infrastructure to add more regions
# Configuration
1. You have to change the domain_name variable in the variables.tf to your domain to get the configuration up and 
running.

2. To allow access to the server instance via ssh you need to configure in the variables.tf the values for 
<mark>*v4_own_ip*</mark> and <mark>*v6_own_ip*</mark> with your own ipv4 and ipv6 address

3. You can change anything else in the configuration easily by overriding the variables in the main.tf or variables.tf 
file in the root folder. \
If you want to change for example the second region to us-east-1, you can edit the variables.tf and change the 
sub_region block to:

variables.tf:
>variable sub_region { \
  description = "The sub region" \
  type = string \
  default = <mark>"us-east-1"</mark> \
}

4. If you want to change some settings, for example the minimum auto-scaling capacity for one region you can either 
simply add this by overriding the variable in the main.tf file, or changing the variable in the variables.tf in the infrastructure 
folder:

/infrastructure/main.tf:
>module "main_region_config" { \
  source = "./infrastructure" \
  region = var.main_region \
  <mark>asg_minimum_capacity = 3</mark> \
}

5. You can easily add other regions by simply using another module block in the main.tf, an example for a third region is 
included, you can activate this by simply uncommenting the block 'module "third_region_config"' in the main.tf in the 
root folder.

# Prerequisites
1. A domain is needed, in the current code an aws domain is used. If you do not own a domain directly by aws, delete the 
last part of the route53.tf file in the root folder which updates the name servers and update them manually at your domain 
provider.
2. AWS CLI (https://aws.amazon.com/cli)
3. Terraform (https://www.terraform.io/downloads)
4. An account in AWS IAM is set up with at-least the rights for:
- AmazonVPCFullAccess
- AmazonEC2FullAccess
- AutoScalingFullAccess
- ElasticLoadBalancingFullAccess
- AmazonRoute53FullAccess

# Usage
<h6>Before you use any terraform command, please make sure the aws cli was configured via the "aws configure" command and 
the access key, secret key and region was set there.</h6>
First initialize the files:

```shell
terraform init
```

With plan, you can check the aws API.

```shell
terraform plan
```

Apply will start the configuration and setup everything accordingly to the configuration file.

```shell
terraform apply -auto-approve
```

After successful deployment of the infrastructure, you will have the ssh keys in the root directory as .pem files which
can be used to generate your private keys to access the servers via ssh. 

If you want to delete the created resources afterwards you can run destroy.

```shell
terraform destroy -auto-approve
```
# Security notices

- Currently, logging is not activated in this configuration, usually you want to log any traffic information into a S3 
bucket or as cloudwatch metric. This includes at-least the ALB traffic flow, VPC flow and DNS queries.
- EC2 instances have public IPs, which is used to connect over SSH to them, normally you want to avoid this and put in 
for example some terminal instance in the cloud, which is only accessible via a VPN and which can connect then to the 
instances.
- For SSH access your own IP is needed, this could be a security issue, even if your ISP changes your IP daily,
if you upload your configuration to a GitHub Repository or somewhere else. 
- Currently, load balancer have no deletion protection, this can be a problem when applying a changed configuration, 
usually you would activate this. It is currently deactivated to allow rapid deployment and destruction, else destroy 
will fail without deactivating the protection first.
- HTTP access in general is not safe, HTTPs should be used anywhere it's possible.
- For any public accessible component you should have a firewall as further security measure, in this case especially 
the application load balancer.
- DNSSec is currently not activated, this should be in general to secure DNS attack surfaces.

# Further Documentation

On every push terraform-doc will automatically generate via a GitHub action documents. \
The files are found as [TERRAFORM.md](TERRAFORM.md) for the root folder and in the infrastructure folder [TERRAFORM.md](infrastructure/TERRAFORM.md).
# Contributing

If you'd like to contribute, please fork the repository and make changes as you'd like. \
Pull requests are warmly welcome.
