resource "aws_cloudwatch_event_rule" "check_batches" {
  name                = "${var.project}-${var.environment}-check-batches-rule"
  schedule_expression = var.batch_poll_schedule
}

resource "aws_cloudwatch_event_target" "check_batches_lambda" {
  rule = aws_cloudwatch_event_rule.check_batches.name
  arn  = aws_lambda_function.check_batches.arn
}
