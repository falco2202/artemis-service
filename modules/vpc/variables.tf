variable "project_name" {
  type        = string
  description = "Project name"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block of the vpc"
}

variable "public_subnets_cidr_block" {
  type        = list(string)
  description = "CIDR block for Public Subnet"
}

variable "database_subnets_cidr_block" {
  type        = list(string)
  description = "Database subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "AZ in which all the resources will be deployed"
}
