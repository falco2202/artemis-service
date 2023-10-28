variable "instance_type" {
  type        = string
  description = "Value of instance type"
}

variable "agent_sg_id" {
  type        = string
  description = "Value of agent security group ID"
}

variable "subnet_id" {
  type        = string
  description = "Value of subnet ID"
}

variable "public_key" {
  description = "Public key instance"
}
