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

variable "openai_api_key" {
  description = "OpenAI API Key"
  type        = string
  nullable    = false
}

variable "openai_model_name" {
  description = "OpenAI Model Name"
  type        = string
  nullable    = false
}

variable "batch_poll_schedule" {
  description = "Schedule for batch polling in EventBridge format, e.g. rate(30 minutes)"
  type        = string
  default     = "rate(30 minutes)"
}

locals {
  base_domain = var.domain
  subdomain   = var.environment == "production" ? local.base_domain : "${var.environment}.${local.base_domain}"
}
