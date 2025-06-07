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
