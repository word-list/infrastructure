resource "aws_lambda_function" "check_batches" {
  function_name    = "${var.project}-${var.environment}-check-batches"
  handler          = "WordList.Processing.CheckBatches"
  runtime          = "dotnet8"
  role             = aws_iam_role.check_batches.arn
  architectures    = ["arm64"]
  filename         = "placeholder.zip"
  source_code_hash = filebase64sha256("placeholder.zip")
  timeout          = 60
  environment {
    variables = {
      BATCHES_TABLE_NAME = var.batches_table_name
      PROMPTS_TABLE_NAME = var.prompts_table_name
      OPENAI_API_KEY     = var.openai_api_key
      OPENAI_MODEL_NAME  = var.openai_model_name
    }
  }
}

resource "aws_lambda_permission" "check_batches_eventbridge" {
  statement_id  = "AllowEventBridgeToInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.check_batches.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.check_batches.arn
}
