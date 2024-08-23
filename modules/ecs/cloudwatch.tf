resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${local.resource_name}"
}
