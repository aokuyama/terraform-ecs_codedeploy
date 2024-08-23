module "ecs" {
  source                   = "./modules/ecs"
  region                   = var.region
  vpc_id                   = var.vpc_id
  subnet_ids               = data.aws_subnets.this.ids
  domain                   = var.domain
  github_repository        = var.github_repository
  ecr_repository_name      = aws_ecr_repository.app.name
  app_server_desired_count = 1
}
