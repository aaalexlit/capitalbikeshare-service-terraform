#Log the load balancer app url
output "app_url" {
  value = aws_alb.application_load_balancer.dns_name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.prediction_service_ecr_repo.repository_url
}

output "task_definition_json" {
  value = jsonencode({
    taskDefinition = {
      containerDefinitions = jsonencode(aws_ecs_task_definition.service_task.container_definitions)
      taskDefinitionArn    = aws_ecs_task_definition.service_task.arn
      volumes              = aws_ecs_task_definition.service_task.volume
    }
  })
}

output "container_name" {
  value = aws_ecs_task_definition.service_task.container_definitions.name
}

output "ecs_service" {
  value = aws_ecs_service.app_service.name
}

output "ecs_cluster" {
  value = aws_ecs_cluster.ecs_cluster.name
}
