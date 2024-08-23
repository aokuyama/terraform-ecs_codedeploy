resource "aws_ecs_task_definition" "app" {
  family       = local.resource_name
  cpu          = "256"
  memory       = "512"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  container_definitions = templatefile("${path.module}/taskdef.json", {
    "resource_name"        = local.resource_name
    "container_name"       = local.container_name_app
    "image_repository_url" = data.aws_ecr_repository.app.repository_url,
    "image_tag"            = "deploy"
    "tz"                   = "Asia/Tokyo"
    "region"               = var.region
  })
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.task.arn
}

resource "aws_iam_role" "ecs_execution" {
  name = "${local.resource_name}-ecs"

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchFullAccessV2",
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
  ]
}

resource "aws_iam_role" "task" {
  name = "${local.resource_name}-task"

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
  ]
}
