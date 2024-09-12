output "instance_ips" {
  value = aws_instance.frontend[*].public_ip
}

output "elb_dns_name" {
  value = aws_lb.frontend_lb
}
