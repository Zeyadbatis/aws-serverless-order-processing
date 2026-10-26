output "API_URL" {
  description = "url for submitting orders"
  value       = "${aws_api_gateway_stage.api_stage.invoke_url}/orders"
}

output "SQS_URL" {
  description = "url for sqs"
  value       = aws_sqs_queue.sqs.url
}
