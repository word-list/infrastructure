output "update_words_queue_url" {
  value       = aws_sqs_queue.update_words.url
  description = "Input queue URL"
}

output "update_words_queue_policy_arn" {
  value = aws_iam_policy.update_words_queue.arn
}
