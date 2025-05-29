output "process_source_chunk_queue_url" {
  value       = aws_sqs_queue.process_source_chunk.url
  description = "Input queue URL"
}

output "process_source_chunk_queue_policy_arn" {
  value = aws_iam_policy.process_source_chunk_queue.arn
}
