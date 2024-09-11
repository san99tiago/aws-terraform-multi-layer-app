resource "aws_instance" "web" {
  count                       = 2
  ami                         = var.instance_ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[count.index].id
  security_groups             = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name # Key must be created in AWS before running Terraform
  user_data                   = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl enable httpd
    sudo systemctl start httpd
    sudo echo "<html><h1>APACHE SEVER WORKING</h1></html>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "web-instance-${count.index + 1}"
  }
}

# TODO: Enhance userdata with scripts to initialize custom repo/apps
