resource "aws_lambda_function" "process_source_chunk" {
  function_name    = "${var.project}-${var.environment}-process-source-chunk"
  handler          = "WordList.Processing.ProcessSourceChunk"
  runtime          = "dotnet8"
  role             = aws_iam_role.process_source_chunk.arn
  architectures    = ["arm64"]
  filename         = "placeholder.zip"
  source_code_hash = filebase64sha256("placeholder.zip")
  timeout          = 60
  environment {
    variables = {
      SOURCE_CHUNKS_TABLE_NAME     = var.source_chunks_table_name
      SOURCE_CHUNKS_BUCKET_NAME    = var.source_chunks_bucket_name
      WORDS_TABLE_NAME             = var.words_table_name
      QUERY_WORD_QUEUE_URL         = var.query_word_queue_url
      DEBUG_OUTGOING_MESSAGE_LIMIT = "5"
    }
  }
}

resource "aws_lambda_event_source_mapping" "process_source_chunk_sqs_trigger" {
  event_source_arn = aws_sqs_queue.process_source_chunk.arn
  function_name    = aws_lambda_function.process_source_chunk.arn
  batch_size       = 1

  scaling_config {
    maximum_concurrency = 2
  }
}
