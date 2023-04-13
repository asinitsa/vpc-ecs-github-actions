resource "aws_lb" "dev" {
  name               = "dev-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.allow-http.id,
    module.vpc.default_security_group_id
  ]
  subnets = module.vpc.public_subnets

  tags = {
    Name        = "dev-alb",
    Environment = "dev"
  }
}

#resource "aws_lb_listener" "rebike80" {
#  load_balancer_arn = aws_lb.dev.arn
#  port              = "80"
#  protocol          = "HTTP"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.nginx.arn
#  }
#
#  tags = {
#    Name        = "http",
#    Environment = "dev"
#  }
#}

################# Target groups #########
resource "aws_lb_target_group" "nginx" {
  name        = "nginx-dev-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
  health_check {
    path    = "/"
    port    = "80"
    matcher = "200,301,302"
  }
  tags = {
    Name        = "nginx-dev-tg",
    Environment = "dev"
  }
}