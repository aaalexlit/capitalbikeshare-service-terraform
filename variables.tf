variable "ecr_repo_name" {
  type        = string
  description = "ECR repo name"
  default     = "capitalbikeshare-dv-model-pipeline"
}

variable "environment" {
  type        = string
  description = "Environment name"
}
