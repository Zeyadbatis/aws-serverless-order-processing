output "API_URL" {
  description = "url for submitting orders"
  value       = local.api_url
}

output "SQS_URL" {
  description = "url for sqs"
  value       = aws_sqs_queue.sqs.url
}
