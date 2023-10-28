output "vpc_id" {
  value       = aws_vpc.artemis.id
  description = "VPC ID"
}

output "public_subnets_id" {
  value       = aws_subnet.public_subnets.*.id
  description = "List public subnets ID"
}

output "database_subnets_id" {
  value       = aws_subnet.database_subnets.*.id
  description = "List database subnets ID"
}

output "public_sg_id" {
  value       = [aws_security_group.public_sg.id]
  description = "Public security group"
}

output "database_sg_id" {
  value       = [aws_security_group.database_sg.id]
  description = "Database security group"
}

output "agent_sg_id" {
  value       = aws_security_group.agent_sg.id
  description = "Agent security group"
}

output "efs_sg_id" {
  value       = aws_security_group.efs_sg.id
  description = "EFS security group"
}
