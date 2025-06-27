resource "aws_iam_role" "query_words" {
  name = "${var.project}-${var.environment}-query-words-role"

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

resource "aws_iam_policy" "query_words_queue" {
  name = "${var.project}-${var.environment}-query-words-queue-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = aws_sqs_queue.query_words.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "query_words" {
  for_each = {
    query_words_queue          = aws_iam_policy.query_words_queue.arn
    batches_table              = var.batches_table_policy_arn
    prompts_table              = var.prompts_table_policy_arn
    word_attributes_table      = var.word_attributes_table_policy_arn
    source_update_status_table = var.source_update_status_table_policy_arn
    basic_logging              = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }

  role       = aws_iam_role.query_words.name
  policy_arn = each.value
}
