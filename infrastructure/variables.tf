// Region specific
variable region {
  description = "The main region"
  type = string
  default = "eu-central-1"
}
// ETC
variable "vpc_v4_cidr_block" {
  description = "Available v4 cidr blocks for public subnets."
  type        = list(string)
  default     = [
    "10.0.0.0/16",
  ]
}
variable "subnet_v4_cidr_blocks" {
  description = "Available v4 cidr blocks for public subnets."
  type        = list(string)
  default     = [
    "10.0.0.0/17",
    "10.0.128.0/17",
  ]
}
variable "cidr_v4_everywhere" {
  description = "cidr block for everywhere"
  type        = string
  default     = "0.0.0.0/0"
}
variable "cidr_v4_ssh_own_ip" {
  description = "cidr block for everywhere"
  type        = string
  default     = "127.0.0.1/32"
}
variable "cidr_v6_ssh_own_ip" {
  description = "cidr block for everywhere"
  type        = string
  default     = "::1/128"
}
variable "cidr_v6_everywhere" {
  description = "cidr block for everywhere"
  type        = string
  default     = "::/0"
}
variable "key_name" {
  description = "The key name"
  type        = string
  default     = "myKey"
}
variable "key_algorithm" {
  description = "The key algorithm"
  type        = string
  default     = "RSA"
}
variable "key_bit_size" {
  description = "The key bit size"
  type        = number
  default     = 2048
}
variable "key_file_name" {
  description = "The key name"
  type        = string
  default     = "myKey.pem"
}
variable "instances_type" {
  description = "The instances type"
  type        = string
  default     = "t2.micro"
}
variable "asg_desired_capacity" {
  description = "The desired auto scaling instance capacity"
  type        = number
  default     = "2"
}
variable "asg_minimum_capacity" {
  description = "The minimum auto scaling instance capacity"
  type        = number
  default     = "2"
}
variable "asg_maximum_capacity" {
  description = "The maximum auto scaling instance capacity"
  type        = number
  default     = "5"
}
variable "asg_warm_pool_min_size" {
  description = "The minimum size of the warm pool instances for auto scaling"
  type        = number
  default     = "1"
}
variable "asg_warm_pool_max_size" {
  description = "The maximum size of the warm pool instances for auto scaling"
  type        = number
  default     = "2"
}
variable "asg_default_cooldown" {
  description = "The time before another scaling activity starts"
  type        = number
  default     = "60"
}
variable "asg_health_check_grace_period" {
  description = "The time until a health check is performed on a fresh instance"
  type        = number
  default     = "60"
}

