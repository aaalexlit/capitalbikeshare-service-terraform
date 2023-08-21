variable "ecr_repo_name" {
  type        = string
  description = "ECR repo name"
  default     = "capitalbikeshare-dv-model-pipeline"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "cpu" {
  type        = number
  description = "ECS CPU to set to the tasks."
}

variable "memory" {
  type        = number
  description = "ECS memory to set to the tasks."
}

variable "region" {
  type        = string
  description = "AWS Region where to create the resources."
}

variable "desired_count" {
  type        = number
  description = "How many ECS Tasks to initialy deploy per service."
}
