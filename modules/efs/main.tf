resource "aws_efs_file_system" "artemis_service" {
  creation_token   = "artemis-efs"
  performance_mode = "generalPurpose"
  encrypted        = true
}

resource "aws_efs_mount_target" "artemis_service" {
  count           = length(var.public_subnets_id)
  file_system_id  = aws_efs_file_system.artemis_service.id
  security_groups = [var.efs_sg_id]
  subnet_id       = var.public_subnets_id[count.index]
}

resource "aws_efs_access_point" "artemis" {
  file_system_id = aws_efs_file_system.artemis_service.id

  root_directory {
    path = "/artemis-data"
    creation_info {
      owner_gid   = 1001
      owner_uid   = 1001
      permissions = "777"
    }
  }
  posix_user {
    uid = 1000
    gid = 1000
  }
}
