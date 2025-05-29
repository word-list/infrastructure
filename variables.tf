variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "staging"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "wordlist"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "domain" {
  description = "The base domain name.  A subdomain will be added for non-production environments."
  type        = string
  nullable    = false
}

locals {
  base_domain = var.domain
  subdomain   = var.environment == "production" ? local.base_domain : "${var.environment}.${local.base_domain}"
}
