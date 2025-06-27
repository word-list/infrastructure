variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "sources_table_name" {
  type = string
}

variable "source_chunks_table_name" {
  type = string
}

variable "source_chunks_bucket_name" {
  type = string
}

variable "sources_table_policy_arn" {
  type = string
}

variable "source_chunks_table_policy_arn" {
  type = string
}

variable "process_source_chunks_queue_policy_arn" {
  type = string
}

variable "deployment_artifacts_bucket_policy_arn" {
  type = string
}

variable "source_chunks_bucket_policy_arn" {
  type = string
}

variable "process_source_chunk_queue_url" {
  type = string
}

variable "source_update_status_table_name" {
  type = string
}

variable "source_update_status_table_policy_arn" {
  type = string
}

