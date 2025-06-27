resource "aws_lambda_function" "upload_source_chunks" {
  function_name    = "${var.project}-${var.environment}-upload-source-chunks"
  handler          = "WordList.Processing.UploadSourceChunks"
  runtime          = "dotnet8"
  role             = aws_iam_role.upload_source_chunks.arn
  architectures    = ["arm64"]
  filename         = "placeholder.zip"
  source_code_hash = filebase64sha256("placeholder.zip")
  timeout          = 60
  environment {
    variables = {
      SOURCES_TABLE_NAME              = var.sources_table_name
      SOURCE_CHUNKS_BUCKET_NAME       = var.source_chunks_bucket_name
      PROCESS_SOURCE_CHUNK_QUEUE_URL  = var.process_source_chunk_queue_url
      SOURCE_UPDATE_STATUS_TABLE_NAME = var.source_update_status_table_name
    }
  }
}
