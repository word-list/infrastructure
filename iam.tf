
resource "aws_iam_policy" "sources_table" {
  name = "${var.project}-${var.environment}-sources-table-policy"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan"
        ],
        "Resource": "${aws_dynamodb_table.sources.arn}"
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "source_update_status_table" {
  name = "${var.project}-${var.environment}-source-update-status-table-policy"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan"
        ],
        "Resource": "${aws_dynamodb_table.source_update_status.arn}"
      }
    ]
  }
  EOF
}


resource "aws_iam_policy" "source_chunks_table" {
  name = "${var.project}-${var.environment}-source-chunks-table-policy"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan"
        ],
        "Resource": "${aws_dynamodb_table.source_chunks.arn}"
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "batches_table" {
  name = "${var.project}-${var.environment}-batches-table-policy"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:BatchGetItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ],
        "Resource": [
          "${aws_dynamodb_table.batches.arn}",
          "${aws_dynamodb_table.batches.arn}/index/StatusIndex"
        ]
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "prompts_table" {
  name = "${var.project}-${var.environment}-prompts-table-policy"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ],
        "Resource": "${aws_dynamodb_table.prompts.arn}"
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "word_attributes_table" {
  name = "${var.project}-${var.environment}-word-attributes-table-policy"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [          
          "dynamodb:GetItem",          
          "dynamodb:BatchGetItem",          
          "dynamodb:Scan",
          "dynamodb:Query"
        ],
        "Resource": "${aws_dynamodb_table.word_attributes.arn}"
      }
    ]
  }
  EOF
}

resource "aws_iam_policy" "deployment_artifacts_bucket" {
  name = "${var.project}-${var.environment}-deployment-artifacts-bucket-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      Effect = "Allow"
      Resource = [
        aws_s3_bucket.deployment_artifacts.arn,
        "${aws_s3_bucket.deployment_artifacts.arn}/*"
      ]
    }]
  })
}

resource "aws_iam_policy" "source_chunks_bucket" {
  name = "${var.project}-${var.environment}-source-chunks-bucket-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject",
        "s3:DeleteObject"
      ]
      Effect = "Allow"
      Resource = [
        aws_s3_bucket.source_chunks.arn,
        "${aws_s3_bucket.source_chunks.arn}/*"
      ]
    }]
  })
}
