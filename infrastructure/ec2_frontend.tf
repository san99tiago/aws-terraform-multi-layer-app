############################################
# LOCAL VARIABLES
############################################
locals {
  # Set environment variables to be appended to /etc/profile
  env_vars = <<-EOF
    #!/bin/bash
    echo export BACKEND_URL="${aws_instance.backend.private_dns}" >> /etc/profile
    source /etc/profile
  EOF

  # Combine environment variables with the user_data script
  user_data_with_env = "${local.env_vars}\n${file("./scripts/user_data_frontend.sh")}"
}

############################################
# FRONTEND EC2 INSTANCE
############################################
resource "aws_instance" "frontend" {
  count                       = 2
  ami                         = var.instance_ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[count.index].id
  security_groups             = [aws_security_group.ec2_frontend_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name # Key must be created in AWS before running Terraform

  # Instance profile to enable SSM Session Manager and CloudWatch Logs
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Use the combined user_data that includes env vars
  user_data = local.user_data_with_env

  tags = {
    Name = "frontend-instance-${count.index + 1}"
  }

  # Add dependency on backend instance
  depends_on = [aws_instance.backend]
}
