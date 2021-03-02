variable "aliases" {
  type    = list(any)
  default = []
}

variable "domain" {
  type = string
}

variable "zone_id" {
  type = string
}
