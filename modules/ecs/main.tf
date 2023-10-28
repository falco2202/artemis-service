locals {
  volume_config = jsondecode(file("../volume-config/${var.volume_file}"))
}

resource "aws_ecs_task_definition" "task_defintion" {
  family             = var.service.name
  network_mode       = "awsvpc"
  cpu                = var.service.cpu
  memory             = var.service.memory
  execution_role_arn = var.execution_role_arn

  dynamic "volume" {
    for_each = local.volume_config
    content {
      name = volume.value.name
    }
  }

  container_definitions = templatefile("../task-definitions/${var.task_defintion}", {
    container_name = var.service.container_name,
    password       = var.password
  })
}

resource "aws_ecs_service" "service_app" {
  name                = var.service.name
  launch_type         = "FARGATE"
  cluster             = var.ecs_cluster_id
  task_definition     = aws_ecs_task_definition.task_defintion.arn
  desired_count       = var.service.desired_count
  scheduling_strategy = "REPLICA"

  depends_on = [aws_ecs_task_definition.task_defintion]

  network_configuration {
    subnets          = var.public_subnets_id
    security_groups  = var.security_group_id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_port   = var.service.container_port
    container_name   = var.service.container_name
  }
}

# resource "aws_appautoscaling_target" "autoscaling_group" {
#   max_capacity       = var.service.autoscaling.max_capacity
#   min_capacity       = var.service.autoscaling.min_capacity
#   resource_id        = "service/${lower("${var.project_name}-cluster")}/${aws_ecs_service.service_app.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "ecs_policy" {
#   name               = "${var.service.name}-ecs-policy"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.autoscaling_group.resource_id
#   scalable_dimension = aws_appautoscaling_target.autoscaling_group.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.autoscaling_group.service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }

#     target_value = var.service.autoscaling.cpu.target_value
#   }
# }
