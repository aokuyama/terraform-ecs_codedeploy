data "aws_vpc" "self" {
  id = var.vpc_id
}
data "aws_ecr_repository" "app" {
  name = var.ecr_repository_name
}
data "aws_acm_certificate" "self" {
  domain   = var.domain
  statuses = ["ISSUED"]
}
