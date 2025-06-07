resource "aws_iam_role" "update_words" {
  name = "${var.project}-${var.environment}-update-words-role"

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

resource "aws_iam_role_policy_attachment" "update_words" {
  for_each = {
    update_words_queue = aws_iam_policy.update_words_queue.arn
    basic_logging      = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }

  role       = aws_iam_role.update_words.name
  policy_arn = each.value
}
