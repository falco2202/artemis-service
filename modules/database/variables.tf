variable "database_subnets_id" {
  description = "Database subnet id"
}

variable "project_name" {
  type = string
}

variable "database_sg_id" {
  description = "Database sg"
}

variable "vpc_id" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "instance_class" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}
