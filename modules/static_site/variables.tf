variable "bucket_name" {
  description = "Name of the s3 bucket. Must be unique."
  type        = string
}

variable "root_document" {
  description = "root html document for CFD"
  type        = string
}

variable "s3_origin_id" {
  description = "Name of the s3 Origin user for CF"
  type        = string
  default     = "myS3Origin"
}

variable "aliases" {
  description = "Aliases associated with Cloudfront distribution"
  type        = list(any)
  default     = []
}
