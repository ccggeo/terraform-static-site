output "zone_id" {
  description = "R53 zone id"
  value       = module.zones.this_route53_zone_zone_id
}
output "name_servers" {
  description = "Name servers created by r53 zone"
  value       = module.zones.this_route53_zone_name_servers
}

output "cloudfront_hostname" {
  description = "Hostname of the deployed cloudfront distribution"
  value       = module.static_site.cloudfront_hostname
}
