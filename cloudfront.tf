resource "aws_cloudfront_distribution" "dev_cloudfront" {
  enabled         = true
  comment         = "cache distribution"
  is_ipv6_enabled = true
  price_class     = "PriceClass_All"


  origin {
    origin_id   = aws_s3_bucket.dev.id
    domain_name = aws_s3_bucket.dev.bucket_regional_domain_name
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.dev_identity.cloudfront_access_identity_path
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  default_cache_behavior {
    target_origin_id       = aws_s3_bucket.dev.id
    viewer_protocol_policy = "redirect-to-https"
    cached_methods         = ["GET", "HEAD"]
    allowed_methods        = ["GET", "HEAD"]
    forwarded_values {
      query_string = false
      headers      = []
      cookies {
        forward = "none"
      }
    }
  }
  ordered_cache_behavior {
    path_pattern     = "/public/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.dev.id

    forwarded_values {
      query_string = false
      headers      = []
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
resource "aws_cloudfront_origin_access_identity" "dev_identity" {
  comment = "My CloudFront OAI"
}