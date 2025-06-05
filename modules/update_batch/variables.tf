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

variable "update_words_queue_url" {
  type = string
}

variable "update_words_queue_policy_arn" {
  type = string
}

variable "query_words_queue_url" {
  type = string
}

variable "query_words_queue_policy_arn" {
  type = string
}
