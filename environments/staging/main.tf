provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source      = "../../modules/vpc"
  app_name    = var.app_name
  environment = "staging"
}

module "ecr" {
  source      = "../../modules/ecr"
  app_name    = var.app_name
  environment = "staging"
}

resource "aws_iam_role" "ecs_execution" {
  name = "${var.app_name}-staging-ecs-execution"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task" {
  name = "${var.app_name}-staging-ecs-task"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

module "ecs" {
  source             = "../../modules/ecs"
  app_name           = var.app_name
  environment        = "staging"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  ecr_repository_url = module.ecr.repository_url
  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.ecs_task.arn
  aws_region         = var.aws_region
  container_port     = 80
}

module "iam_oidc" {
  source      = "../../modules/iam-oidc"
  app_name    = var.app_name
  environment = "staging"
  github_org  = var.github_org
  github_repo = var.app_repo_name
  infra_repo  = var.infra_repo_name
}

output "alb_url" {
  value       = "http://${module.ecs.alb_dns_name}"
  description = "Your live site URL"
}
output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "Push Docker images here"
}
output "github_actions_role_arn" {
  value       = module.iam_oidc.github_actions_role_arn
  description = "Use this in AWS_ROLE_ARN GitHub secret"
}
output "terraform_role_arn" {
  value       = module.iam_oidc.terraform_role_arn
  description = "Use this in infra-repo GitHub secret"
}
output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}
output "ecs_service_name" {
  value = module.ecs.service_name
}

resource "aws_sns_topic" "alerts" {
  name = "${var.app_name}-staging-alerts"
  tags = {
    Environment = "staging"
    Purpose     = "pipeline-test"
  }
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}