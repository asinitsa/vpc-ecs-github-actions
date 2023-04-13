resource "aws_ecs_cluster" "dev" {
  name = "dev"
}

resource "aws_ecs_task_definition" "task-definition" {
  family                   = var.service-name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.shared-ecs-task-execution.arn
  task_role_arn            = aws_iam_role.shared-ecs-task-execution.arn
  container_definitions = jsonencode([
    {
      name      = var.service-name
      image     = var.service-image
      essential = true
      portMappings = [{
        protocol      = "tcp"
        containerPort = 80
        hostPort      = 80
      }]
      environment = [{
        name  = "ENV"
        value = "dev"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.logs.name
          awslogs-region        = "eu-central-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "service" {
  name                   = var.service-name
  cluster                = aws_ecs_cluster.dev.name
  launch_type            = "FARGATE"
  task_definition        = aws_ecs_task_definition.task-definition.arn
  enable_execute_command = true
  desired_count          = 1
  network_configuration {
    security_groups = [
      aws_security_group.allow-http.id,
      module.vpc.default_security_group_id
    ]
    subnets = module.vpc.private_subnets
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.nginx.arn
    container_name   = var.service-name
    container_port   = 80
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/dev/${var.service-name}/"
  retention_in_days = "14"
}
