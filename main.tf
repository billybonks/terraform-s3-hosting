# Add s3 bucket with a policy referencing the role we created above
resource "aws_s3_bucket" "frontend" {
  bucket = "${var.domain_name}"
  acl = "public-read"
  force_destroy = true
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_cloudfront_distribution" "frontend" {
  origin {
    domain_name = "${aws_s3_bucket.frontend.bucket_regional_domain_name}"
    origin_id   = "${aws_s3_bucket.frontend.bucket}"
  }

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    target_origin_id       = "${aws_s3_bucket.frontend.bucket}"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${vars.acm_arn}"
    minimum_protocol_version = "TLSv1_2016"
    ssl_support_method = "sni-only"
  }

  custom_error_response {
    error_code         = "404"
    response_page_path = "/index.html"
    response_code      = "200"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [
    "${var.domain_name}",
  ]

  price_class = "PriceClass_200"
}
