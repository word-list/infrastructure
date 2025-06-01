resource "aws_lambda_function" "query_words" {
  function_name    = "${var.project}-${var.environment}-query-words"
  handler          = "WordList.Processing.QueryWords"
  runtime          = "dotnet8"
  role             = aws_iam_role.query_words.arn
  architectures    = ["arm64"]
  filename         = "placeholder.zip"
  source_code_hash = filebase64sha256("placeholder.zip")
  timeout          = 60
  environment {
    variables = {
      BATCHES_TABLE_NAME = var.batches_table_name
      PROMPTS_TABLE_NAME = var.prompts_table_name
      OPENAI_API_KEY     = var.openai_api_key
    }
  }
}

resource "aws_lambda_event_source_mapping" "query_words_sqs_trigger" {
  event_source_arn                   = aws_sqs_queue.query_words.arn
  function_name                      = aws_lambda_function.query_words.arn
  batch_size                         = 1000
  maximum_batching_window_in_seconds = 60

  scaling_config {
    maximum_concurrency = 2
  }
}
