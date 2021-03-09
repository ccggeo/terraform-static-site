variable "aliases" {
  description = "Aliases to be applied on the CFN distribution/R53"
  type        = list(any)
  default     = [""]
}

variable "default_environment" {
  description = "Environment to deploy to (for tagging)"
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Bucket name to deploy to"
  type        = string
  default     = ""
}

variable "root_document" {
  description = "Root document for CFN distrubtion"
  type        = string
  default     = ""
}
