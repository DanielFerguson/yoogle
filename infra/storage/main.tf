resource "aws_s3_bucket" "web_bucket" {
  bucket        = "www.yoogle.app"
  force_destroy = true

  tags = var.tags
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
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.web_bucket.bucket}/*"
        ]
      }
    ]
  })

  depends_on = [
    aws_s3_bucket_ownership_controls.web_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.web_bucket_public_access_block,
  ]
}

resource "aws_iam_user" "s3_user" {
  name = "yoogle-s3-access-user"

  tags = var.tags
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
        Effect = "Allow"
        Action = [
          "s3:*",
        ],
        Resource = "arn:aws:s3:::${aws_s3_bucket.web_bucket.bucket}/*"
      }
    ]
  })
}
