resource "aws_iam_role" "process_source_chunk" {
  name = "${var.project}-${var.environment}-process-source-chunk-role"

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

resource "aws_iam_policy" "process_source_chunk_queue" {
  name = "${var.project}-${var.environment}-process-source-chunk-queue-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = aws_sqs_queue.process_source_chunk.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "process_source_chunk" {
  for_each = {
    process_source_chunk_queue = aws_iam_policy.process_source_chunk_queue.arn
    query_word_queue           = var.query_word_queue_policy_arn
    words_table                = var.words_table_policy_arn
    source_chunks_bucket       = var.source_chunks_bucket_policy_arn
    source_chunks_table        = var.source_chunks_table_policy_arn
    basic_logging              = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }

  role       = aws_iam_role.process_source_chunk.name
  policy_arn = each.value
}
