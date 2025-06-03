resource "aws_iam_role" "check_batches" {
  name = "${var.project}-${var.environment}-check-batches-role"

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

resource "aws_iam_role_policy_attachment" "check_batches" {
  for_each = {
    words_table        = var.words_table_policy_arn
    batches_table      = var.batches_table_policy_arn
    prompts_table      = var.prompts_table_policy_arn
    update_batch_queue = var.update_batch_queue_policy_arn
    basic_logging      = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  }

  role       = aws_iam_role.check_batches.name
  policy_arn = each.value
}
