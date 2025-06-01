resource "aws_sqs_queue" "query_words" {
  name                       = "${var.project}-${var.environment}-query-words-queue"
  visibility_timeout_seconds = 3600
  message_retention_seconds  = 86400
}
