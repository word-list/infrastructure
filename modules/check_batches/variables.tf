variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "batches_table_name" {
  type = string
}

variable "batches_table_policy_arn" {
  type = string
}

variable "prompts_table_name" {
  type = string
}

variable "prompts_table_policy_arn" {
  type = string
}

variable "openai_api_key" {
  type = string
}

variable "openai_model_name" {
  type = string
}

variable "batch_poll_schedule" {
  type = string
}

variable "update_batch_queue_url" {
  type = string
}

variable "update_batch_queue_policy_arn" {
  type = string
}

variable "source_update_status_table_name" {
  type = string
}

variable "source_update_status_table_policy_arn" {
  type = string
}

