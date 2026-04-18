variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region to deploy into"
}

variable "app_name" {
  type        = string
  default     = "myapp"
  description = "Application name used for naming all resources"
}

variable "github_org" {
  type        = string
  description = "Your GitHub username or organisation"
}

variable "app_repo_name" {
  type        = string
  description = "GitHub repo name for the React app"
}

variable "infra_repo_name" {
  type        = string
  description = "GitHub repo name for this Terraform code"
}
