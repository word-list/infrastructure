resource "aws_dynamodb_table" "sources" {
  name           = "${var.project}-${var.environment}-sources-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1    # Number of read units
  write_capacity = 1    # Number of write units
  hash_key       = "id" # Primary key  

  attribute {
    name = "id"
    type = "S" # String type
  }
}

resource "aws_dynamodb_table" "source_chunks" {
  name           = "${var.project}-${var.environment}-source-chunks-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "words" {
  name           = "${var.project}-${var.environment}-words-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 15
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "batches" {
  name           = "${var.project}-${var.environment}-batches-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  global_secondary_index {
    name            = "StatusIndex"
    hash_key        = "status"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 1
  }
}

resource "aws_dynamodb_table" "prompts" {
  name           = "${var.project}-${var.environment}-prompts-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "batch_id"
  range_key      = "prompt_id"

  attribute {
    name = "batch_id"
    type = "S"
  }

  attribute {
    name = "prompt_id"
    type = "S"
  }
}
