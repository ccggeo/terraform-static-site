terraform {
  required_version = "~> 0.14.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  alias  = "west"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "east"
  region = "us-east-1"
}


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
  version       = "~> 1.0"
  source        = "./modules/static_site"
  bucket_name   = var.bucket_name
  root_document = var.root_document
  aws_cert_val  = module.aws_cert.aws_acm_certificate_arn
  aliases       = var.aliases
  environment   = var.default_environment
  providers = {
    aws = aws.west
  }
}

module "aws_cert" {
  version = "~> 1.0"
  aliases = var.aliases
  source  = "./modules/aws_cert"
  domain  = var.aliases[0]
  zone_id = values(module.zones.this_route53_zone_zone_id)[0]
  providers = {
    aws = aws.east
  }
}
