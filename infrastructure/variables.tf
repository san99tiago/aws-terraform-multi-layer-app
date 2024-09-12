############################################
# General Variables
############################################
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name for the application"
  type        = string
  default     = "demo-app"
}

############################################
# VPC Variables
############################################
variable "vpc_cidr_block" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/21"
}

variable "aws_availability_zones" {
  description = "Availability Zones for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_public_subnets_cidr" {
  description = "CIDRs for the VPC public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_private_subnets_cidr" {
  description = "CIDRs for the VPC private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for the VPC"
  type        = bool
  default     = true # For cheaper alternatives, set to false
}

############################################
# EC2 Variables
############################################
variable "instance_ami_id" {
  description = "AMI ID (Amazon Machine Image) for the EC2 instance"
  type        = string
  default     = "ami-0182f373e66f89c85"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

# IMPORTANT: Key must be created in AWS before running Terraform!!!
variable "key_name" {
  description = "SSH Key Pair Name for the EC2 instance"
  type        = string
  default     = "santi-tests"
}

############################################
# ELB Variables
############################################
variable "elb_name" {
  description = "Name for the Application Load Balancer"
  type        = string
  default     = "cool-app"
}

############################################
# RDS Variables
############################################
variable "db_user" {
  description = "RDS database user"
  type        = string
  default     = "admin"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "movie_db"
}
