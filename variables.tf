variable domain_name {
  description = "The domain name"
  type = string
  default = "subpair.click"
}
variable main_region {
  description = "The main region"
  type = string
  default = "eu-central-1"
}
variable sub_region {
  description = "The sub region"
  type = string
  default = "us-west-1"
}
variable third_region {
  description = "The third region"
  type = string
  default = "ca-central-1"
}
variable "v4_own_ip" {
  description = "v4 ip address for ssh access"
  type        = string
  default     = "87.166.101.116/32"
}
variable "v6_own_ip" {
  description = "v6 ip address for ssh access"
  type        = string
  default     = "2003:F8:4715:E0D:7934:1299:2D9C:B207/128"
}
