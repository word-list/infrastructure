resource "aws_iam_policy" "query_word_queue" {
  name = "${var.project}-${var.environment}-query-word-queue-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage"]
        Resource = aws_sqs_queue.query_word.arn
      },
    ]
  })
}
