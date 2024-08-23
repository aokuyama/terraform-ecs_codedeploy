terraform {
  required_providers {
    aws = {
      version = "5.64.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.2.3"
    }
  }
}

provider "aws" {
  region = var.region
}
provider "github" {
  token = var.github_token
}
