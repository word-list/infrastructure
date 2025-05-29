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

variable "query_word_queue_policy_arn" {
  type = string
}

variable "words_table_policy_arn" {
  type = string
}

variable "source_chunks_bucket_policy_arn" {
  type = string
}

variable "words_table_name" {
  type = string
}

variable "query_word_queue_url" {
  type = string
}
