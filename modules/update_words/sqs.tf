resource "aws_sqs_queue" "update_words" {
  name                       = "${var.project}-${var.environment}-update-words-queue"
  visibility_timeout_seconds = 3600
  message_retention_seconds  = 86400
}
