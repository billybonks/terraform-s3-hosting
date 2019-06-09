variable "sub_domain" {
  description = "name of the hosted app"
  type = "string"
}

variable "app_domain" {
  description = "The domain prefix for the bucket name, which comes after either `s3-asset-path`"
  type = "string"
}

locals {
  website_url = "${var.subdomain}.${var.app_domain}"
}
