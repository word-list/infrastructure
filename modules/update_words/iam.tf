resource "aws_iam_policy" "update_words_queue" {
  name = "${var.project}-${var.environment}-update-words-queue-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = aws_sqs_queue.update_words.arn
      },
    ]
  })
}
