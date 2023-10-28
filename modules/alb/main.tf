resource "aws_lb" "artemis_lb" {
  count              = length(var.public_subnets_id)
  name               = "${var.service_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_id
  subnets            = element(var.public_subnets_id, count.index)
}

resource "aws_alb_target_group" "alb_target_group" {
  name        = "${var.service_name}-tg-service"
  port        = var.lb_port
  protocol    = var.lb_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol            = var.lb_protocol
    path                = var.lb_path
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 120
  }

  depends_on = [aws_lb.artemis_lb]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.artemis_lb[0].id
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
}
