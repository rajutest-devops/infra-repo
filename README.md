# infra-repo

Terraform infrastructure for The Pair of Pearls application.
Single environment — staging.

## Before you apply

Update these two files with your actual values:

### 1. environments/staging/backend.tf
Change the bucket name to match your S3 bucket:
  bucket = "your-actual-bucket-name"

### 2. environments/staging/terraform.tfvars
Fill in your GitHub details:
  github_org      = "your-github-username"
  app_repo_name   = "app-repo"
  infra_repo_name = "infra-repo"

## How to apply

  cd environments/staging
  terraform init
  terraform plan
  terraform apply

## Outputs after apply

  alb_url                  = your live site URL
  ecr_repository_url       = push Docker images here
  github_actions_role_arn  = use in app-repo GitHub secret AWS_ROLE_ARN
  terraform_role_arn       = use in infra-repo GitHub secret

## Future backend

When you add a Node.js backend later, add a second ECS service
with container_port = 3000 and ALB path routing /api/* to it.
