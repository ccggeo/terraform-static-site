resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment  = "Block access to everyone except CF"
  provider = aws.west
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  #tfsec:ignore:AWS045
  origin {
    domain_name = aws_s3_bucket.origin_bucket.bucket_regional_domain_name
    origin_id   = var.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  comment             = "Deploy static site behind Cloudfront"
  default_root_object = var.root_document

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.origin_bucket_logs.bucket_domain_name
    prefix          = var.bucket_name
  }

  aliases = var.aliases

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }

  tags = {
    Environment = var.environment
  }

  viewer_certificate {
    acm_certificate_arn      = var.aws_cert_val
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }
}

