resource "aws_sqs_queue" "query_word" {
  name                       = "${var.project}-${var.environment}-query-word-queue"
  visibility_timeout_seconds = 3600
  message_retention_seconds  = 86400
}
