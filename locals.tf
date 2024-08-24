locals {
  resource_name = "ecs-example"
  github_actions_variables = {
    aws_region             = var.region
    aws_deploy_arn         = aws_iam_role.deploy.arn
    aws_ecr_name           = aws_ecr_repository.app.name
    aws_ecs_task_family    = module.ecs.ecs_task_family
    aws_ecs_container_name = module.ecs.ecs_container_name
    aws_ecs_service        = module.ecs.ecs_service
    aws_ecs_cluster        = module.ecs.ecs_cluster
  }
}
