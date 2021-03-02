resource "aws_s3_bucket" "origin_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket" "origin_bucket_logs" {
  bucket = "logs.${var.bucket_name}"
  acl    = "private"

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_policy" "origin_policy" {
  bucket = aws_s3_bucket.origin_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "origin_access_bucket_policy"
    Statement = [
      {
        Sid    = "origin_access"
        Effect = "Allow"
        Principal = {
          "AWS" : aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
        }
        Action = "s3:GetObject"
        Resource = [
          "${aws_s3_bucket.origin_bucket.arn}/*",
        ]
      },
    ]
  })
}
