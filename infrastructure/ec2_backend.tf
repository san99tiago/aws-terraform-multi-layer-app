############################################
# LOCAL VARIABLES FOR BACKEND
############################################
locals {
  # Set environment variables for database settings
  # TODO: Update to a more "secure" approach with SSM Parameter Store or Secrets Manager
  env_vars_backend = <<-EOF
    #!/bin/bash
    echo export DB_HOST="${aws_db_instance.mysql_rds.address}" >> /etc/profile
    echo export DB_PASS="${random_password.rds_password.result}" >> /etc/profile
    echo export DB_USER="${var.db_user}" >> /etc/profile
    echo export DB_NAME="${var.db_name}" >> /etc/profile
    echo export S3_BUCKET="${aws_s3_bucket.source_files.bucket}" >> /etc/profile
    echo export SERVER_PORT="${var.backend_port}" >> /etc/profile
    source /etc/profile
  EOF


  # Combine environment variables with the user_data script
  user_data_with_env_backend = "${local.env_vars_backend}\n${file("./scripts/user_data_backend.sh")}"
}

############################################
# BACKEND EC2 INSTANCE
############################################
resource "aws_instance" "backend" {
  count = var.total_backend_instances

  ami                         = var.instance_ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private[count.index].id # Assuming private subnet
  security_groups             = [aws_security_group.ec2_backend_sg.id]
  associate_public_ip_address = false # No public IP for backend
  # key_name                    = var.key_name

  # Instance profile to enable SSM Session Manager and CloudWatch Logs
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Use the combined user_data that includes env vars
  user_data = local.user_data_with_env_backend

  tags = {
    Name = "backend-instance-${count.index + 1}"
  }

  # Add dependency on RDS instance
  depends_on = [null_resource.upload_backend_to_s3, aws_db_instance.mysql_rds]
}
