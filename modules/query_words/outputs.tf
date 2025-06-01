output "query_words_queue_url" {
  value       = aws_sqs_queue.query_words.url
  description = "Input queue URL"
}

output "query_words_queue_policy_arn" {
  value = aws_iam_policy.query_words_queue.arn
}
