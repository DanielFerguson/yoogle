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

module "cicd" {
  source = "./cicd"

  aws_region            = var.aws_region
  repository_name       = local.repository_name
  aws_s3_bucket_id      = module.storage.aws_s3_bucket_id
  aws_access_key_id     = module.storage.aws_access_key_id
  aws_secret_access_key = module.storage.aws_secret_access_key
}

module "dns" {
  source = "./dns"

  cloudflare_zone_id = var.cloudflare_zone_id
  website_endpoint   = module.storage.s3_website_endpoint
}

module "storage" {
  source = "./storage"

  tags = local.tags
}
