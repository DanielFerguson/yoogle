terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.33"
    }

    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "github" {}

locals {
  tags = {
    Project   = "yoogle"
    Terraform = "true"
  }
  repository_name = "yoogle"
}

module "dns" {
  source = "./dns"

  cloudflare_zone_id = var.cloudflare_zone_id
  api_gateway_url    = module.compute.api_gateway_url
}

module "compute" {
  source = "./compute"
}

module "hosting" {
  source = "./hosting"

  tags                         = local.tags
  github_personal_access_token = var.github_personal_access_token
}
