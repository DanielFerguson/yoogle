output "s3_website_endpoint" {
  value = aws_s3_bucket_website_configuration.web_bucket_website_configuration.website_endpoint
}

output "aws_s3_bucket_id" {
  value = aws_s3_bucket.web_bucket.id
}

output "aws_access_key_id" {
  value     = aws_iam_access_key.s3_user_key.id
  sensitive = true
}

output "aws_secret_access_key" {
  value     = aws_iam_access_key.s3_user_key.secret
  sensitive = true
}
