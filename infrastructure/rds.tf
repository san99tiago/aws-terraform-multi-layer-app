############################################
# PASSWORD MANAGEMENT FOR DATABASE (SIMPLE)
############################################

# Generate a random password and store it in SSM Parameter Store (non-encrypted)
resource "random_password" "rds_password" {
  length  = 16
  special = false
}
resource "aws_ssm_parameter" "rds_password" {
  name  = "/rds/${var.app_name}/admin_password"
  type  = "String"
  value = random_password.rds_password.result
}

############################################
# RDS DATABASE
############################################

# RDS MySQL Instance (Only one for now. Demo purposes)
# TODO: Add automation to execute the "database/init.sql" script (now manual by DBA)
resource "aws_db_instance" "mysql_rds" {
  identifier             = "${var.app_name}-database"
  engine                 = "mysql"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  port                   = 3306
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_name                = "movie_db"
  username               = "admin"
  password               = random_password.rds_password.result
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true  # For demo purposes. Not recommended for production
  publicly_accessible    = false # Only accessible from the VPC
}

# RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${replace(var.app_name, "-", "_")}_rds_subnet_group"
  subnet_ids  = aws_subnet.private[*].id
  description = "RDS Subnet Group for ${var.app_name}"
}

