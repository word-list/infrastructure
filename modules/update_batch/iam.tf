resource "aws_iam_policy" "update_batch_queue" {
  name = "${var.project}-${var.environment}-update-batch-queue-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = aws_sqs_queue.update_batch.arn
      },
    ]
  })
}
