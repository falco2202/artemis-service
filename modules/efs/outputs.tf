output "efs_id" {
  value = aws_efs_file_system.artemis_service.id
}

output "access_point_id" {
  value = aws_efs_access_point.artemis.id
}
