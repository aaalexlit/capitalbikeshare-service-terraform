terraform {
  required_version = ">= 1.5"
  backend "s3" {
    bucket  = "terraform-state-mlops-zoomcamp"
    key     = "capitalbikeshare-mlops.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
  required_providers {
    aws = "~> 5.9"
  }
}

resource "aws_ecr_repository" "app_ecr_repo" {
  name                 = "${var.environment}-${var.ecr_repo_name}"
  force_delete         = true
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}
