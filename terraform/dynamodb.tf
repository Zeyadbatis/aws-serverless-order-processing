# DynamoDB table with streams enabled

resource "aws_dynamodb_table" "orders_table" {
  name         = "orders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "email"
  range_key    = "order_id"

  attribute {
    name = "order_id"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  # Enable DynamoDB Streams
  stream_enabled = false



}
