resource "aws_lb" "this" {
  name    = local.resource_name
  subnets = var.subnet_ids
}

resource "aws_lb_listener" "this_443" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }
}
