resource "aws_amplify_app" "web" {
  name       = "yoogle-web"
  repository = "https://github.com/danielferguson/yoogle"

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  access_token = var.github_personal_access_token

  enable_auto_branch_creation = true

  auto_branch_creation_patterns = [
    "*",
    "*/**",
  ]

  auto_branch_creation_config {
    enable_auto_build = true
  }

  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - pnpm install
        build:
          commands:
            - pnpm run build
      artifacts:
        baseDirectory: build
        files:
          - apps/web/*
      cache:
        paths:
          - node_modules/**/*
  EOT
}

resource "aws_amplify_branch" "main" {
  app_id       = aws_amplify_app.web.id
  branch_name  = "main"
  display_name = "production"

  framework = "React"
  stage     = "PRODUCTION"

  enable_auto_build       = true
  enable_performance_mode = true

  tags = var.tags
}
