resource "aws_cloudfront_distribution" "cdn" {
  enabled = true

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  origin {
    domain_name = aws_s3_bucket.frontend.bucket_regional_domain_name
    origin_id   = "S3-Frontend"
  }

  origin {
    domain_name = module.api.invoke_url
    origin_id   = "API-Gateway"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-Frontend"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    path_pattern           = "/api/*"
    target_origin_id       = "API-Gateway"
    viewer_protocol_policy = "https-only"
  }
}
