variable "region" {
  type    = string
  default = "ap-northeast-1"
}
variable "vpc_id" { type = string }
variable "subnet_names" { type = list(string) }
variable "domain" { type = string }
variable "github_token" { type = string }
variable "github_repository" { type = string }
