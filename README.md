# A scalable and high-available simple webpage on AWS

This repository contains infrastructure-as-code for a highly available and scalable simple webpage on AWS. \
It was written for the IU University's course *"DLBSEPCP01_E" - Cloud Programming"*. \
This code was written for Terraform v1.3.5.

# Contains

This configuration contains:
- Auto-scaling and load balanced Ec2 infrastructure with a minimal webserver deployment in two regions
- Route53 latency routing to the 2 load balanced regions

# Configuration

You can change the configuration easily by overriding the variables in the main.tf or variables.tf file in the root 
folder. \
If you want to change for example the second region to us-west-1, you can edit the variables.tf and change the subregion
block to:

variables.tf \
variable sub_region { \
  description = "The sub region" \
  type = string \
  default = <mark>"us-west-1"</mark> \
}

If you want to change some settings, for example the minimum auto-scaling capacity for one region you can simply add 
this by overriding the variable in the main.tf file`s block:

main.tf \
module "main_region_config" { \
  source = "./infrastructure" \
  region = var.main_region \
  <mark>asg_minimum_capacity = 3</mark> \
}
# Prerequisites
- A domain is needed, in the current code an aws domain is used. If you do not own a domain directly by aws, delete the 
last part of the main.tf file in the root folder which updates the name servers and update them manually at your domain 
provider.
- AWS CLI (https://aws.amazon.com/cli)
- Terraform (https://www.terraform.io/downloads)

# Usage
<h6>Before you use any terraform command, please make sure the aws cli was configured via the "aws configure" command and 
the access key, secret key and region was set there.</h6>
First initialize the files:

```shell
terraform init
```

With plan you can check the aws API.

```shell
terraform plan
```

Apply will apply the configuration and setup everything accordingly to the configuration file.

```shell
terraform apply -auto-approve
```

After successful deployment of the infrastructure, you will have the ssh keys in the root directory as .pem files which
can be used to generate your private keys to access the servers via ssh. 

If you want to delete the created resources afterwards you can run destroy.

```shell
terraform destroy -auto-approve
```

# Contributing

If you'd like to contribute, please fork the repository and make changes as you'd like. \
Pull requests are warmly welcome.
