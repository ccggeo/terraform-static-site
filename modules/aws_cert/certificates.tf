# https://stackoverflow.com/questions/50067317/terraform-creating-and-validating-multiple-acm-certificates
# https://github.com/hashicorp/terraform/issues/18359

resource "aws_acm_certificate" "cert" {
  provider = aws.east
  count             = length(var.aliases)
  domain_name       = element(var.aliases, count.index)
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "cert" {
  provider = aws.east
  count                   = length(var.aliases)
  certificate_arn         = element(aws_acm_certificate.cert.*.arn, count.index)
  validation_record_fqdns = [element(aws_route53_record.cert_validation.*.fqdn, count.index)]
  depends_on = [aws_acm_certificate.cert]
}

output "aws_acm_certificate_arn"{
  value = aws_acm_certificate.cert[0].arn
}
