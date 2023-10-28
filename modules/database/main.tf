resource "aws_db_subnet_group" "artemis_db" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.database_subnets_id
}


resource "aws_db_parameter_group" "custom_mysql" {
  name   = "custom-mysql"
  family = "mysql8.0"

  parameter {
    name         = "lower_case_table_names"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8mb4_unicode_ci"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_instance" "artemis_db" {
  allocated_storage      = var.allocated_storage
  db_name                = "${var.project_name}_database"
  engine                 = "mysql"
  engine_version         = "8.0.33"
  instance_class         = var.instance_class
  username               = var.username
  password               = var.password
  parameter_group_name   = aws_db_parameter_group.custom_mysql.name
  vpc_security_group_ids = [var.database_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.artemis_db.name
  skip_final_snapshot    = true

  depends_on = [aws_db_parameter_group.custom_mysql]
}
