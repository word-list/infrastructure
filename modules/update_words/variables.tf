variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "db_connection_string" {
  type      = string
  sensitive = true
}

variable "word_attributes_table_name" {
  type = string
}

variable "word_attributes_table_policy_arn" {
  type = string
}
