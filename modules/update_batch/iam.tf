resource "aws_iam_role" "update_batch" {
  name = "${var.project}-${var.environment}-update-batch-role"

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

resource "aws_iam_role_policy_attachment" "update_batch" {
  for_each = {
    batches_table      = var.batches_table_policy_arn
    prompts_table      = var.prompts_table_policy_arn
    update_words_queue = var.update_words_queue_policy_arn
    query_words_queue  = var.query_words_queue_policy_arn
    update_batch_queue = aws_iam_policy.update_batch_queue.arn
    basic_logging      = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }

  role       = aws_iam_role.update_batch.name
  policy_arn = each.value
}
