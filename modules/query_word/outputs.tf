output "query_word_queue_url" {
  value       = aws_sqs_queue.query_word.url
  description = "Input queue URL"
}

output "query_word_queue_policy_arn" {
  value = aws_iam_policy.query_word_queue.arn
}
