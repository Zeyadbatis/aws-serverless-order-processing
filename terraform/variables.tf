variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
  description = "Region where to provision Lambda"
}

variable "bucket_name" {
  default = "static_website"
}
#lambda

#API_GateWay

variable "api_http_method" {
  type        = string
  default     = "POST"
  description = "Method to trigger Lambda through API Gateway"
}
