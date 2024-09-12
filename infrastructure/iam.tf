############################################
# IAM ROLE FOR EC2 INSTANCE
# (SAME FOR FRONTEND AND BACKEND... FOR NOW)
############################################
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

############################################
# ATTACH MANAGED POLICIES TO THE ROLE
############################################
resource "aws_iam_role_policy_attachment" "backend_ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "backend_cloudwatch_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

############################################
# INSTANCE PROFILE FOR BACKEND EC2 INSTANCE
############################################
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${replace(var.app_name, "-", "_")}_instance_profile"
  role = aws_iam_role.ec2_role.name
}
