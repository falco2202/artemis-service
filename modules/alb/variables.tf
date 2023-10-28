variable "vpc_id" {
  type = string
}

variable "security_group_id" {
  description = "value of security group id"
}

variable "public_subnets_id" {
  description = "value of public subnets id"
}

variable "service_name" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "lb_port" {
  type = number
}

variable "lb_protocol" {
  type = string
}

variable "lb_path" {
  type = string
}
