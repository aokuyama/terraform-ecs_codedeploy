locals {
  resource_name = "ecs-example"
  github_actions_variables = {
    aws_region     = var.region
    aws_deploy_arn = aws_iam_role.deploy.arn
    aws_ecr_name   = aws_ecr_repository.app.name
  }
}
