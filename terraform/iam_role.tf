# IAM role for order submiting lambda: API_GateWay => lambda => SQS
data "aws_iam_policy_document" "submitting_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "submitting_role" {
  name               = "submitting_role"
  assume_role_policy = data.aws_iam_policy_document.submitting_role_policy.json
}



resource "aws_iam_role_policy" "submiting_sqs" {
  name = "submiting-sqs-access"
  role = aws_iam_role.submitting_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : aws_sqs_queue.sqs.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "submiting_logs" {

  role       = aws_iam_role.submitting_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}





# IAM role for order processing lambda: SQS => lambda => Dynomodb
data "aws_iam_policy_document" "processing_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "processing_role" {
  name               = "processing_role"
  assume_role_policy = data.aws_iam_policy_document.processing_role_policy.json
}

resource "aws_iam_role_policy" "processing_sqs" {
  name = "processing-sqs-access"
  role = aws_iam_role.processing_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ]
      Resource = aws_sqs_queue.sqs.arn
    }]
  })
}

resource "aws_iam_role_policy" "processing_dynomodb" {
  name = "processing_dynomodb"
  role = aws_iam_role.processing_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["dynamodb:PutItem"], Effect = "Allow", Resource = aws_dynamodb_table.orders_table.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "processing_logs" {

  role       = aws_iam_role.processing_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

