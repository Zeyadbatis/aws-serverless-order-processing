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

