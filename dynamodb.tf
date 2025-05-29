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

