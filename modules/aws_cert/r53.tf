locals {
  dvo = flatten(aws_acm_certificate.cert.*.domain_validation_options)
}

resource "aws_route53_record" "cert_validation" {
  count   = length(var.aliases)
  zone_id = var.zone_id
  ttl     = 60

  name    = lookup(local.dvo[count.index], "resource_record_name")
  type    = lookup(local.dvo[count.index], "resource_record_type")
  records = [lookup(local.dvo[count.index], "resource_record_value")]

}
