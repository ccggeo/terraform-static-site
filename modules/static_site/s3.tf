resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}


resource "aws_s3_bucket" "origin_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name = var.bucket_name
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  logging {
    target_bucket = aws_s3_bucket.origin_bucket_logs.id
    target_prefix = "log/"
  }

}


resource "aws_s3_bucket" "origin_bucket_logs" {
  bucket = "logs.${var.bucket_name}"
  acl    = "private"

  tags = {
    Name = var.bucket_name
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  logging {
    target_bucket = aws_s3_bucket.origin_bucket_logs.id
    target_prefix = "log/"
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
