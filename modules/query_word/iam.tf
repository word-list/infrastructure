resource "aws_iam_role" "query_word" {
  name = "${var.project}-${var.environment}-query-word-role"

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

resource "aws_iam_policy" "query_word_queue" {
  name = "${var.project}-${var.environment}-query-word-queue-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = aws_sqs_queue.query_word.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "query_word" {
  for_each = {
    query_word_queue = aws_iam_policy.query_word_queue.arn
    words_table      = var.words_table_policy_arn
    batches_table    = var.batches_table_policy_arn
    basic_logging    = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }

  role       = aws_iam_role.query_word.name
  policy_arn = each.value
}
