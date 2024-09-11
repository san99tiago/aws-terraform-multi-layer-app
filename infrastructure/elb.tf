resource "aws_lb" "web_lb" {
  name                       = var.elb_name
  load_balancer_type         = "application"
  internal                   = false
  security_groups            = [aws_security_group.elb_sg.id]
  subnets                    = aws_subnet.public.*.id
  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true
  enable_http2                     = true
}


# Crear el grupo de destino para el ALB
resource "aws_lb_target_group" "web_tg" {
  name     = "alb-target-group-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 300
    timeout             = 10
    healthy_threshold   = 5
    unhealthy_threshold = 5
    path                = "/"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "web_instance" {
  count            = 2
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}
