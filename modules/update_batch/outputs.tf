output "update_batch_queue_url" {
  value       = aws_sqs_queue.update_batch.url
  description = "Input queue URL"
}

output "update_batch_queue_policy_arn" {
  value = aws_iam_policy.update_batch_queue.arn
}
