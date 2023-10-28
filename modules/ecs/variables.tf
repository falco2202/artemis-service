variable "ecs_cluster_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "public_subnets_id" {
  type = list(string)
}

variable "security_group_id" {
  description = "Publib sg"
}

variable "target_group_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "volume_file" {
  type = string
}

variable "task_defintion" {
  type        = string
  description = "File task defintion"
}

variable "password" {
}

variable "service" {
  type = object({
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
  })
}
