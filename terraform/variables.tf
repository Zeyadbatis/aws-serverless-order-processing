variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
  description = "Region where to provision Lambda"
}

variable "bucket_name" {
  default = "static-website-zeyad-2026"
  type    = string
}
#lambda
variable "lambda_timeout" {
  type        = number
  default     = 10
  description = "lambda timeout in seconds"
}
variable "lambda_memory_size" {
  type        = number
  default     = 128
  description = "size of lambda memory in MB"

}

#API_GateWay

variable "api_http_method" {
  type        = string
  default     = "POST"
  description = "Method to trigger Lambda through API Gateway"
}

variable "domain_name" {
  default     = "zeyadbatis.com"
  description = "domain name"
  type        = string
}

