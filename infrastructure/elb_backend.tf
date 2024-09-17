############################################
# PRIVATE ELB FOR BACKEND INSTANCES
############################################

# Create an internal (private) Application Load Balancer
resource "aws_lb" "backend_lb" {
  name                       = "${var.elb_name}-backend"
  load_balancer_type         = "application"
  internal                   = true                                   # Set to true for internal
  security_groups            = [aws_security_group.elb_backend_sg.id] # Security group for private ELB
  subnets                    = aws_subnet.private.*.id                # Use private subnets
  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true
  enable_http2                     = true
}

# Create a target group for the backend ELB (private)
resource "aws_lb_target_group" "backend_tg" {
  name     = "alb-target-group-backend"
  port     = var.backend_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    path                = "/" # Change this to your app's health check path if needed
  }
}

# Create a listener for the backend ELB
resource "aws_lb_listener" "http_backend" {
  load_balancer_arn = aws_lb.backend_lb.arn
  port              = var.backend_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}

# Attach private instances to the private target group
resource "aws_lb_target_group_attachment" "private_instance" {
  count            = 2
  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id        = aws_instance.backend[count.index].id # Assuming you are using aws_instance.backend for private instances
  port             = var.backend_port
}
