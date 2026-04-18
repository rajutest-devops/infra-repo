variable "app_name" {
  type = string
}
variable "environment" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "ecr_repository_url" {
  type = string
}
variable "execution_role_arn" {
  type = string
}
variable "task_role_arn" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "container_port" {
  type        = number
  default     = 80
  description = "Port the container listens on. 80 for React/nginx, 3000 for Node.js"
}
variable "task_cpu" {
  type    = string
  default = "256"
}
variable "task_memory" {
  type    = string
  default = "512"
}
variable "desired_count" {
  type    = number
  default = 1
}
