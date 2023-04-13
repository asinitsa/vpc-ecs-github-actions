
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  name = "vpc"
  cidr = "10.34.0.0/16"

  azs              = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets  = ["10.34.0.0/22", "10.34.4.0/22", "10.34.8.0/22"]
  public_subnets   = ["10.34.12.0/22", "10.34.16.0/22", "10.34.20.0/22"]
  database_subnets = ["10.34.24.0/22", "10.34.28.0/22", "10.34.32.0/22", ]

  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "allow-http" {
  name_prefix = "dev-allow-80-"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}