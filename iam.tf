###### IAM for ECS tasks ######
resource "aws_iam_role" "shared-ecs-task-execution" {
  name = "shared-ecs-task-execution-dev"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

# TODO remove extra permissions
resource "aws_iam_role_policy_attachment" "shared-ecs-task-execution-1" {
  role       = aws_iam_role.shared-ecs-task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}