output "aws_acm_certificate_arn" {
  description = "Certificate arn of primary domain"
  value       = aws_acm_certificate.cert[0].arn
}
