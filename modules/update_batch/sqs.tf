resource "aws_sqs_queue" "update_batch" {
  name                       = "${var.project}-${var.environment}-update-batch-queue"
  visibility_timeout_seconds = 3600
  message_retention_seconds  = 86400
}
