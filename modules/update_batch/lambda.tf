resource "aws_lambda_function" "update_batch" {
  function_name    = "${var.project}-${var.environment}-update-batch"
  handler          = "WordList.Processing.UpdateBatch"
  runtime          = "dotnet8"
  role             = aws_iam_role.update_batch.arn
  architectures    = ["arm64"]
  filename         = "placeholder.zip"
  source_code_hash = filebase64sha256("placeholder.zip")
  timeout          = 60
  environment {
    variables = {
      BATCHES_TABLE_NAME              = var.batches_table_name
      PROMPTS_TABLE_NAME              = var.prompts_table_name
      OPENAI_API_KEY                  = var.openai_api_key
      UPDATE_WORDS_QUEUE_URL          = var.update_words_queue_url
      QUERY_WORDS_QUEUE_URL           = var.query_words_queue_url
      WORD_ATTRIBUTES_TABLE_NAME      = var.word_attributes_table_name
      SOURCE_UPDATE_STATUS_TABLE_NAME = var.source_update_status_table_name
    }
  }
}

resource "aws_lambda_event_source_mapping" "update_batch_sqs_trigger" {
  event_source_arn                   = aws_sqs_queue.update_batch.arn
  function_name                      = aws_lambda_function.update_batch.arn
  batch_size                         = 1
  maximum_batching_window_in_seconds = 60

  scaling_config {
    maximum_concurrency = 2
  }
}
