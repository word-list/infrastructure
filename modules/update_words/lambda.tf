resource "aws_lambda_function" "update_words" {
  function_name    = "${var.project}-${var.environment}-update-words"
  handler          = "WordList.Processing.UpdateWords"
  runtime          = "dotnet8"
  role             = aws_iam_role.update_words.arn
  architectures    = ["arm64"]
  filename         = "placeholder.zip"
  source_code_hash = filebase64sha256("placeholder.zip")
  timeout          = 60

  environment {
    variables = {
      DB_CONNECTION_STRING = var.db_connection_string
    }
  }
}

resource "aws_lambda_event_source_mapping" "update_words_sqs_trigger" {
  event_source_arn                   = aws_sqs_queue.update_words.arn
  function_name                      = aws_lambda_function.update_words.arn
  batch_size                         = 1
  maximum_batching_window_in_seconds = 60

  scaling_config {
    maximum_concurrency = 2
  }
}
