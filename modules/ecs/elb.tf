resource "aws_lb" "this" {
  name            = local.resource_name
  subnets         = var.subnet_ids
  security_groups = [aws_security_group.elb.id]
}

resource "aws_lb_listener" "this_443" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  certificate_arn   = data.aws_acm_certificate.self.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }
}

resource "aws_security_group" "elb" {
  name   = "${local.resource_name}-elb"
  vpc_id = var.vpc_id
  tags = {
    Name = "${local.resource_name}-elb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "elb_80" {
  security_group_id = aws_security_group.elb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "elb_443" {
  security_group_id = aws_security_group.elb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "elb" {
  security_group_id = aws_security_group.elb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
