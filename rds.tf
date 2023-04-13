resource "aws_db_subnet_group" "dev-private" {
  name       = "dev-private"
  subnet_ids = module.vpc.database_subnets

  tags = {
    Name        = "dev-private"
    Environment = "dev"
  }
}

resource "random_password" "master" {
  length  = 16
  special = false
  upper   = false
  number  = true
  lower   = true
}

resource "aws_db_instance" "dev" {
  identifier           = "dev"
  instance_class       = "db.t3.small"
  allocated_storage    = 40
  engine               = "postgres"
  engine_version       = "14.7"
  username             = "dev"
  password             = random_password.master.result
  db_subnet_group_name = aws_db_subnet_group.dev-private.name
  vpc_security_group_ids = [
    module.vpc.default_security_group_id
  ]
  publicly_accessible         = false
  skip_final_snapshot         = true
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  backup_retention_period     = 40

  tags = {
    Name        = "dev"
    Terraform   = "true"
    Environment = "dev"
  }
}