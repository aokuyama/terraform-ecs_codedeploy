resource "aws_ecr_repository" "app" {
  name                 = local.resource_name
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}
