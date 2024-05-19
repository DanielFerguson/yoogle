terraform {
  required_providers {
    vercel = {
      source  = "vercel/vercel"
      version = "1.10.1"
    }
  }
}

resource "vercel_project" "yoogle" {
  name      = "yoogle"
  framework = "vite"

  root_directory = "apps/web"
  git_repository = {
    type = "github"
    repo = "danielferguson/yoogle"
  }
}

resource "vercel_deployment" "yoogle" {
  project_id = vercel_project.yoogle.id
  ref        = "main"
}

resource "vercel_project_domain" "yoogle" {
  project_id = vercel_project.yoogle.id
  domain     = "www.yoogle.com"
}

