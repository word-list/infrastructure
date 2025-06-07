variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "source_chunks_table_name" {
  type = string
}

variable "source_chunks_table_policy_arn" {
  type = string
}

variable "source_chunks_bucket_name" {
  type = string
}

variable "query_words_queue_policy_arn" {
  type = string
}

variable "source_chunks_bucket_policy_arn" {
  type = string
}

variable "query_words_queue_url" {
  type = string
}

variable "db_connection_string" {
  type      = string
  sensitive = true
}
