module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 1.0"

  zones = {
    (var.aliases[0]) = {
      tags = {
        env = var.default_environment
      }
    }
  }
  tags = {
    ManagedBy = "Terraform"
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 1.0"

  zone_name = keys(module.zones.this_route53_zone_zone_id)[0]

  records = [
    {
      name = keys(module.zones.this_route53_zone_zone_id)[0]
      type = "CNAME"
      ttl  = 3600
      records = [
        module.static_site.cloudfront_hostname
      ]
    },
  ]

  depends_on = [module.zones]
}

module "static_site" {
  source        = "./modules/static_site"
  bucket_name   = var.bucket_name
  root_document = var.root_document
  aws_cert_val  = module.aws_cert.aws_acm_certificate_arn
  aliases       = var.aliases
  environment   = var.default_environment

}

module "aws_cert" {
  aliases = var.aliases
  source  = "./modules/aws_cert"
  domain  = var.aliases[0]
  zone_id = values(module.zones.this_route53_zone_zone_id)[0]
}

output "zone_id" {
  value = module.zones.this_route53_zone_zone_id
}
output "name_servers" {
  value = module.zones.this_route53_zone_name_servers
}

output "cloudfront_hostname" {
  value = module.static_site.cloudfront_hostname

}
