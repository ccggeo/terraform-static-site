output "cloudfront_hostname" {
  description = "Hostname of the deployed cloudfront distribution"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}
