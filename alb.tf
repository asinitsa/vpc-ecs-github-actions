resource "aws_lb" "dev" {
  name               = "dev-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.allow-http.id
  ]
  subnets = module.vpc.public_subnets

  tags = {
    Name        = "dev-alb",
    Environment = "dev"
  }
}