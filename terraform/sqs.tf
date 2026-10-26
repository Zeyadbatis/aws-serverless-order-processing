resource "aws_sqs_queue" "sqs" {
  name = "sqs"
  //delay_seconds             = 90 # optional
  // max_message_size          = 2048 # optional
  // message_retention_seconds = 86400 # optional
  // receive_wait_time_seconds = 10 # optional

}



resource "aws_lambda_event_source_mapping" "sqs" {
  event_source_arn = aws_sqs_queue.sqs.arn
  function_name    = aws_lambda_function.processing_order_function.arn
  batch_size       = 10

  scaling_config {
    maximum_concurrency = 100
  }
}
