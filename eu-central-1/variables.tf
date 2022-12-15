variable region {
  description = "The main region"
  type = string
  default = "eu-central-1"
}
variable "vpc_cidr_block" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default     = [
    "10.0.0.0/16",
  ]
}
variable "subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default     = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}
variable "subnet-availability_zone" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default     = [
    "eu-central-1a",
    "eu-central-1b",
  ]
}
variable "cidr_everywhere" {
  description = "cidr block for everywhere"
  type        = string
  default     = "0.0.0.0/0"
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
variable "ami" {
  description = "The amazon machine image"
  type        = string
  default     = "ami-076309742d466ad69"
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
