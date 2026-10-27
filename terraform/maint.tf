terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

  }

  backend "s3" {

    bucket       = "zeyad-terraform-state-files"
    key          = "aws-serverless-order-processing/terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true

  }
}

locals {
  s3_origin_id   = "s3-${aws_s3_bucket.first_bucket.id}"
  allowed_origin = "https://${var.domain_name}"
  api_url        = "${aws_api_gateway_stage.api_stage.invoke_url}/orders"

}

data "aws_availability_zones" "available" {
  state = "available"
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
