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

variable "deployment_artifacts_bucket_policy_arn" {
  type = string
}

variable "api_gateway_execution_arn" {
  type = string
}

variable "api_id" {
  type = string
}

variable "authorizer_id" {
  type = string
}

variable "db_connection_string" {
  type      = string
  sensitive = true
}

locals {
  base_domain = var.domain
  subdomain   = var.environment == "production" ? local.base_domain : "${var.environment}.${local.base_domain}"
}
