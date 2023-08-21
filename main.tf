terraform {
  required_version = ">= 1.5"
  backend "s3" {
  }
  required_providers {
    aws = "~> 5.9"
  }
}

resource "aws_ecr_repository" "prediction_service_ecr_repo" {
  name                 = "${var.environment}-${var.ecr_repo_name}"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "main-cluster" # Name your cluster here
}
