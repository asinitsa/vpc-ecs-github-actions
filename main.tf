terraform {
  backend "s3" {
    bucket  = "vpc-ecs-github-actions-tf"
    key     = "services/vpc-ecs-github-actions-tf.tfstate"
    region  = "eu-central-1"
    encrypt = "true"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"
    }
  }
}


provider "aws" {
  region = "eu-central-1"
}

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