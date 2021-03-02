variable "bucket_name" {
  description = "Name of the s3 bucket. Must be unique."
  type        = string
}

variable "root_document" {
  description = "root html document for CFD"
  type        = string
}

variable "s3_origin_id" {
  type    = string
  default = "myS3Origin"
}

variable "aws_cert_val"{}

variable "environment"{
}

variable "aliases" {
  type    = list(any)
  default = []
}
