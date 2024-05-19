variable "repository_name" {
  description = "The name of the GitHub repository"
  type        = string
  default     = "yoogle"
}

variable "aws_s3_bucket_id" {
  description = "The ID of the AWS S3 bucket"
  type        = string
}

variable "aws_access_key_id" {
  description = "The AWS access key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "The AWS secret access key"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}
