output "elb_frontend_dns" {
  value = aws_lb.frontend_lb.dns_name
}

output "frontend_instances_ips" {
  value = aws_instance.frontend[*].public_ip
}

output "elb_backend_dns" {
  value = aws_lb.backend_lb.dns_name
}

output "backend_instances_ips" {
  value = aws_instance.backend[*].private_ip
}

output "rds_address" {
  value = aws_db_instance.mysql_rds.address
}

output "vpc_id" {
  value = aws_vpc.main.id
}
