resource "aws_ecs_service" "app" {
  name                              = local.resource_name
  cluster                           = aws_ecs_cluster.this.id
  task_definition                   = "${aws_ecs_task_definition.app.family}:${aws_ecs_task_definition.app.revision}"
  desired_count                     = var.app_server_desired_count
  health_check_grace_period_seconds = 10
  enable_ecs_managed_tags           = true
  launch_type                       = "FARGATE"
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  load_balancer {
    container_name   = local.container_name_app
    container_port   = 3000
    target_group_arn = aws_lb_target_group.ecs.arn
  }
  network_configuration {
    assign_public_ip = true
    security_groups = [
      aws_security_group.ecs.id,
    ]
    subnets = var.subnet_ids
  }
}

resource "aws_security_group" "ecs" {
  name   = "${local.resource_name}-ecs"
  vpc_id = var.vpc_id
  tags = {
    Name = "${local.resource_name}-ecs"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs" {
  security_group_id = aws_security_group.ecs.id

  cidr_ipv4   = data.aws_vpc.self.cidr_block
  from_port   = 3000
  ip_protocol = "tcp"
  to_port     = 3000
  tags = {
    Name = "${local.resource_name}-ecs"
  }
}

resource "aws_vpc_security_group_egress_rule" "ecs" {
  security_group_id = aws_security_group.ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
