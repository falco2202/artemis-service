### VPC output
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "public_subnets_id" {
  value       = module.vpc.public_subnets_id
  description = "Public subnets ID"
}

output "database_subnets_id" {
  value       = module.vpc.database_subnets_id
  description = "Database subnets ID"
}

output "public_sg_id" {
  value       = module.vpc.public_sg_id
  description = "Public security group ID"
}

output "database_sg_id" {
  value       = module.vpc.database_sg_id
  description = "Database security group ID"
}

output "efs_sg_id" {
  value = module.vpc.efs_sg_id
}

### IAM role
output "ecs_task_execution_role_arn" {
  value = module.iam.ecs_task_execution_role_arn
}

### ECS cluster ID
output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "agent_ip" {
  value = module.ec2_agent.public_ip
}

### EFS id
output "efs_id" {
  value = module.efs.efs_id
}

output "access_point_id" {
  value = module.efs.access_point_id
}
