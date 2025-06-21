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
  read_capacity  = 5
  write_capacity = 5
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

resource "aws_dynamodb_table" "word_attributes" {
  name           = "${var.project}-${var.environment}-word-attributes-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 1
  hash_key       = "name"

  attribute {
    name = "name"
    type = "S"
  }
}

resource "local_file" "word_attributes" {
  content = jsonencode({
    (aws_dynamodb_table.word_attributes.name) = [
      for attr in local.word_attributes : {
        PutRequest = {
          Item = {
            name        = { S = attr.name }
            display     = { S = attr.display }
            description = { S = attr.description }
            prompt      = { S = attr.prompt }
            min         = { N = tostring(attr.min) }
            max         = { N = tostring(attr.max) }
          }
        }
      }
    ]
  })
  filename = "${path.module}/word_attributes.json"
}

resource "null_resource" "load_word_attributes" {
  triggers = {
    file_sha = sha256(local_file.word_attributes.content)
  }

  provisioner "local-exec" {
    command = "aws dynamodb batch-write-item --request-items file://word_attributes.json --region ${var.region}"
  }

  depends_on = [local_file.word_attributes, aws_dynamodb_table.word_attributes]
}
