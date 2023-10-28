### Common variables
variable "region" {
  type        = string
  description = "AWS region"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

### Networking config
variable "vpc_cidr_block" {
  type        = string
  description = "VPC cidr block"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones that the services are running"
}

variable "public_subnets_cidr_block" {
  type        = list(string)
  description = "List cidr block of public subnets"
}

variable "database_subnets_cidr_block" {
  type        = list(string)
  description = "List cidr block of database subnets"
}

### 
variable "host_zone_id" {
  type = string
}

variable "jenkins_domain" {
  type = string
}

variable "jenkins_service_name" {
  type = string
}

variable "gitlab_domain" {
  type = string
}

variable "gitlab_service_name" {
  type = string
}

variable "volume_file_gitlab" {
  type = string
}

variable "volume_file_jenkins" {
  type = string
}

variable "public_key" {
  description = "Public key of instance "
}

variable "service_config" {
  type = map(object({
    name           = string
    host_port      = number
    container_port = number
    container_name = string
    cpu            = number
    memory         = number
    desired_count  = number

    autoscaling = object({
      max_capacity = number
      min_capacity = number
      cpu = object({
        target_value = number
      })
    })
  }))
}

variable "instance_type" {
  type        = string
  description = "Value of instance type"
}

variable "password" {
  type = string
}
