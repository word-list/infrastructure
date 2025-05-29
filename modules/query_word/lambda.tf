resource "aws_lambda_function" "query_word" {
  function_name    = "${var.project}-${var.environment}-query-word"
  handler          = "WordList.Processing.QueryWord"
  runtime          = "dotnet8"
  role             = aws_iam_role.query_word.arn
  architectures    = ["arm64"]
  filename         = "placeholder.zip"
  source_code_hash = filebase64sha256("placeholder.zip")
  timeout          = 60
  environment {
    variables = {
      WORDS_TABLE_NAME   = var.words_table_name
      BATCHES_TABLE_NAME = var.batches_table_name
    }
  }
}

resource "aws_lambda_event_source_mapping" "query_word_sqs_trigger" {
  event_source_arn                   = aws_sqs_queue.query_word.arn
  function_name                      = aws_lambda_function.query_word.arn
  batch_size                         = 1000
  maximum_batching_window_in_seconds = 60

  scaling_config {
    maximum_concurrency = 2
  }
}
