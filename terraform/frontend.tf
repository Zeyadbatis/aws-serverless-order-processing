data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_acm_certificate" "my_domain" {
  provider    = aws.us_east_1
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}


resource "aws_s3_bucket" "first_bucket" {
  bucket = var.bucket_name
}





resource "aws_s3_bucket_public_access_block" "bloch_bucket_access" {
  bucket = aws_s3_bucket.first_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# Origin Access Control (OAC) allows CloudFront to securely access files
# in a private S3 bucket without making the bucket publicly accessible.
# The S3 bucket policy restricts access to the authorized CloudFront distribution.
resource "aws_cloudfront_origin_access_control" "oac" {


  name                              = "bucket_oac"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


data "aws_iam_policy_document" "allow_cloudfront" {
  statement {
    sid    = "AllowCloudFrontReadOnly"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.first_bucket.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn] // this assume distribution was already made (cloud front)
    }
  }
}

resource "aws_s3_bucket_policy" "allow_cloudfront" {

  depends_on = [aws_s3_bucket_public_access_block.bloch_bucket_access]
  bucket     = aws_s3_bucket.first_bucket.id
  policy     = data.aws_iam_policy_document.allow_cloudfront.json
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.first_bucket.id
  key          = "index.html"
  source       = "${path.module}/../frontend/index.html"
  content_type = "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("${path.module}/../frontend/index.html")


}


resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.first_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = local.s3_origin_id
  }

  aliases = [var.domain_name]

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id
  }


  price_class = "PriceClass_100" # Use lower-cost CloudFront edge locations

  restrictions {
    geo_restriction {
      restriction_type = "none"

    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.my_domain.arn
    ssl_support_method  = "sni-only"
  }
}
