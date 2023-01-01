variable "project_name" {
  description = "The project's name"
  type        = string
  default     = "simple-webpage"
}

variable "domain_name" {
  description = "The domain name"
  type        = string
  default     = "subpair.click"
}

variable "main_region" {
  description = "The main region"
  type        = string
  default     = "eu-central-1"
}

variable "sub_region" {
  description = "The sub region"
  type        = string
  default     = "us-west-1"
}

variable "third_region" {
  description = "The third region"
  type        = string
  default     = "ap-northeast-1"
}

variable "v4_own_ip" {
  description = "v4 ip address for ssh access"
  type        = string
  default     = "87.166.106.16/32"
}

variable "v6_own_ip" {
  description = "v6 ip address for ssh access"
  type        = string
  default     = "2003:F8:4712:D584:F488:FEFC:FCFD:C/128"
}

variable "load_balancer_deletion_protection" {
  description = "Activate the load balancer deletion protection to avoid downtimes on terraform configuration updates"
  type        = bool
  default     = false
}

variable "target_port" {
  description = "The application's target port"
  type        = number
  default     = 80
}
