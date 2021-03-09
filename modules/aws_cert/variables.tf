variable "aliases" {
  description = "Aliases associated with Cloudfront distribution"
  type        = list(any)
  default     = []
}

variable "zone_id" {
  description = "Id of the r53 domain"
  type        = string
}
