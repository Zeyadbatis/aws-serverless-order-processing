#lambda function for order submission:
data "archive_file" "submitting_order" {
  type        = "zip"
  source_file = "${path.module}/../lambda/SubmitOrderFunction.py"
  output_path = "${path.module}/lambda/SubmitOrderFunction.zip"
}


resource "aws_lambda_function" "submitting_order_function" {
  filename         = data.archive_file.submitting_order.output_path
  function_name    = "submitting_order_function"
  role             = aws_iam_role.submitting_role.arn
  handler          = "SubmitOrderFunction.lambda_handler"
  source_code_hash = data.archive_file.submitting_order.output_base64sha256
  runtime          = "python3.12"

  environment {

    variables = {
      QUEUE_URL      = aws_sqs_queue.sqs.url
      ALLOWED_ORIGIN = local.allowed_origin
    }
  }

}

#lambda function for order processing:
data "archive_file" "processing_order" {
  type        = "zip"
  source_file = "${path.module}/../lambda/ProcessOrderFunction.py"
  output_path = "${path.module}/lambda/ProcessOrderFunction.zip"
}

resource "aws_lambda_function" "processing_order_function" {
  filename         = data.archive_file.processing_order.output_path
  function_name    = "processing_order_function"
  role             = aws_iam_role.processing_role.arn
  handler          = "ProcessOrderFunction.lambda_handler"
  source_code_hash = data.archive_file.processing_order.output_base64sha256
  runtime          = "python3.12"


  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.orders_table.name
    }
  }

}
