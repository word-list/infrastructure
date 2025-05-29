resource "aws_sqs_queue" "process_source_chunk" {
  name                       = "${var.project}-${var.environment}-process-source-chunk-queue"
  visibility_timeout_seconds = 240
  message_retention_seconds  = 86400
}
