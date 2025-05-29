variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "domain" {
  description = "The base domain name.  A subdomain will be added for non-production environments."
  type        = string
  nullable    = false
}

variable "sources_table_name" {
  type = string
}

variable "sources_table_policy_arn" {
  type = string
}

variable "deployment_artifacts_bucket_policy_arn" {
  type = string
}

locals {
  base_domain = var.domain
  subdomain   = var.environment == "production" ? local.base_domain : "${var.environment}.${local.base_domain}"
}
