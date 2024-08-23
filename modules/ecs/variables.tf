variable "region" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "domain" { type = string }
variable "github_repository" { type = string }
variable "ecr_repository_name" { type = string }
variable "app_server_desired_count" { type = number }
