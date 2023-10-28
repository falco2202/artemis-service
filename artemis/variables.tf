variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "ecs_cluster_id" {
  description = "ECS cluster ID"
  type        = string
}

variable "database_sg_id" {
  description = "Database SG ID"
  type        = string
}

variable "public_sg_id" {
  description = "Public SG ID"
  type        = string
}

variable "public_subnets_id" {
  description = "List public subnets ID"
  type        = list(string)
}

variable "database_subnets_id" {
  description = "List database subnets ID"
  type        = list(string)
}

variable "ecs_task_execution_role_arn" {
  description = "ECS task defintion role"
  type        = string
}

variable "database_username" {
  description = "Database username"
  type        = string
}

variable "database_password" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = string
}

variable "host_zone_id" {
  type = string
}

variable "host_domain_artemis" {
  type = string
}

variable "artemis_service_name" {
  type = string
}

variable "gitlab_url" {
  description = "Gitlab domain"
}

variable "jenkins_url" {
  description = "Jenkisn doamin"
}

variable "gitlab_token" {
  description = "Gitlab token"
}

variable "jenkins_secret_push_token" {
  description = "Jenkins secret token"
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

variable "efs_id" {
  description = "EFS ID"
}

variable "access_point_id" {

}
