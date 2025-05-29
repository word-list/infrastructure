resource "aws_iam_role" "upload_source_chunks" {
  name = "${var.project}-${var.environment}-upload-source-chunks-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "upload_source_chunks" {
  for_each = {
    sources_table               = var.sources_table_policy_arn
    source_chunks_table         = var.source_chunks_table_policy_arn
    process_source_chunks_queue = var.process_source_chunks_queue_policy_arn
    deployment_artifacts_bucket = var.deployment_artifacts_bucket_policy_arn
    source_chunks_bucket        = var.source_chunks_bucket_policy_arn
    basic_logging               = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }

  role       = aws_iam_role.upload_source_chunks.name
  policy_arn = each.value
}
