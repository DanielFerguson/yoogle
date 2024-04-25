terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
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

# web bucket
resource "aws_s3_bucket" "web_bucket" {
  bucket = "yoogle-web"

  tags = {
    Name        = "yoogle-web"
    Environment = "prod"
  }
}

resource "aws_s3_bucket_website_configuration" "web_bucket_website_configuration" {
  bucket = aws_s3_bucket.web_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "web_bucket_ownership_controls" {
  bucket = aws_s3_bucket.web_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "web_bucket_public_access_block" {
  bucket = aws_s3_bucket.web_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "web_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.web_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.web_bucket_public_access_block,
  ]

  bucket = aws_s3_bucket.web_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "web_bucket_policy" {
  bucket = aws_s3_bucket.web_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = ["arn:aws:s3:::${aws_s3_bucket.web_bucket.bucket}/*"]
      }
    ]
  })
}

resource "cloudflare_record" "yoogle_web_root_dns_record" {
  name    = "@"
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id

  value   = "www.yoogle.com"
  ttl     = 1
  proxied = true
  comment = "Redirect @ to www"
}

resource "cloudflare_record" "yoogle_web_www_dns_record" {
  name    = "www"
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id

  value   = aws_s3_bucket_website_configuration.web_bucket_website_configuration.website_endpoint
  ttl     = 1
  proxied = true
  comment = "Point www to the S3 bucket"
}

resource "aws_iam_user" "s3_user" {
  name = "yoogle-s3-access-user"
}

resource "aws_iam_access_key" "s3_user_key" {
  user = aws_iam_user.s3_user.name
}

resource "aws_iam_user_policy" "s3_user_policy" {
  name = "s3-put-object-policy"
  user = aws_iam_user.s3_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.web_bucket.bucket}/*"
      }
    ]
  })
}

resource "github_actions_secret" "ga_bucket_variable" {
  repository      = "yoogle"
  secret_name     = "AWS_S3_BUCKET"
  encrypted_value = aws_s3_bucket.web_bucket.id

  depends_on = [aws_s3_bucket.web_bucket]
}

resource "github_actions_secret" "ga_access_key_id_variable" {
  repository      = "yoogle"
  secret_name     = "AWS_ACCESS_KEY_ID"
  encrypted_value = aws_iam_access_key.s3_user_key.id

  depends_on = [aws_iam_access_key.s3_user_key]
}

resource "github_actions_secret" "ga_secret_access_key_variable" {
  repository      = "yoogle"
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  encrypted_value = aws_iam_access_key.s3_user_key.secret

  depends_on = [aws_iam_access_key.s3_user_key]
}

resource "github_actions_secret" "ga_aws_region_variable" {
  repository      = "yoogle"
  secret_name     = "AWS_REGION"
  encrypted_value = var.aws_region

  depends_on = [aws_iam_access_key.s3_user_key]
}

