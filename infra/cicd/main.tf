resource "github_actions_secret" "ga_bucket_variable" {
  repository      = var.repository_name
  secret_name     = "AWS_S3_BUCKET"
  plaintext_value = var.aws_s3_bucket_id
}

resource "github_actions_secret" "ga_access_key_id_variable" {
  repository      = var.repository_name
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = var.aws_access_key_id
}

resource "github_actions_secret" "ga_secret_access_key_variable" {
  repository      = var.repository_name
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.aws_secret_access_key
}

resource "github_actions_secret" "ga_aws_region_variable" {
  repository      = var.repository_name
  secret_name     = "AWS_REGION"
  plaintext_value = var.aws_region
}
