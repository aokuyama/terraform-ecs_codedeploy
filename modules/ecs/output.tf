output "ecs_task_family" {
  value = aws_ecs_task_definition.app.family
}
output "ecs_container_name" {
  value = local.container_name_app
}
output "ecs_service" {
  value = aws_ecs_service.app.name
}
output "ecs_cluster" {
  value = aws_ecs_cluster.this.name
}
output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution.arn
}
output "ecs_task_role_arn" {
  value = aws_iam_role.task.arn
}
output "ecs_service_id" {
  value = aws_ecs_service.app.id
}
