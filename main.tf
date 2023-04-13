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
