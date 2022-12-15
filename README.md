# A highly scalable and high-available simple webpage on AWS

This repository contains infrastructure-as-code for a highly available and scalable simple webpage on AWS.

It was written for the IU University's course *"DLBSEPCP01_E" - Cloud Programming"*.

This code was written for Terraform v1.3.5.

# Usage

First initialize the files:
```shell
terraform init -var-file="variables.tfvars"
```
With plan you can check the aws API.
```shell
terraform plan -var-file="variables.tfvars"
```
Apply will apply the configuration and setup everything accordingly to the configuration file.
```shell
terraform apply -var-file="variables.tfvars"
```



# Contributing

If you'd like to contribute, please fork the repository and make changes as you'd like. \
Pull requests are warmly welcome.
