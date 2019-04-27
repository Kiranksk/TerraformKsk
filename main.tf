resource "aws_cloudfront_distribution" "default" {
  enabled             = "${var.enabled}"
  is_ipv6_enabled     = "${var.is_ipv6_enabled}"
  comment             = "${var.comment}"
  default_root_object = "${var.default_root_object}"
  price_class         = "${var.price_class}"

  logging_config = {
    include_cookies = "${var.log_include_cookies}"
    bucket          = "westpac-demo.s3.amazonaws.com"
    prefix          = "${var.log_prefix}"
  }

  aliases = ["${var.aliases}"]

  custom_error_response = ["${var.custom_error_response}"]

  origin {
    domain_name = "example.com.au"
    origin_id   = "itsUniqFuck"
    origin_path = "${var.origin_path}"

    custom_origin_config {
      http_port                = "${var.origin_http_port}"
      https_port               = "${var.origin_https_port}"
      origin_protocol_policy   = "${var.origin_protocol_policy}"
      origin_ssl_protocols     = "${var.origin_ssl_protocols}"
      origin_keepalive_timeout = "${var.origin_keepalive_timeout}"
      origin_read_timeout      = "${var.origin_read_timeout}"
    }
  }

  origin {
    domain_name = "westpac-demo.s3.amazonaws.com"
    origin_id   = "S3-westpac-demo"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E26UOA9QB8E8AZ"
    }
  }
  viewer_certificate {
    acm_certificate_arn            = "${var.acm_certificate_arn}"
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "${var.viewer_minimum_protocol_version}"
    cloudfront_default_certificate = "${var.acm_certificate_arn == "" ? true : false}"
  }

  default_cache_behavior {
    allowed_methods  = "${var.allowed_methods}"
    cached_methods   = "${var.cached_methods}"
    target_origin_id = "itsUniqFuck"
    compress         = "${var.compress}"

    forwarded_values {
      headers = ["${var.forward_headers}"]

      query_string = "${var.forward_query_string}"

      cookies {
        forward           = "${var.forward_cookies}"
        whitelisted_names = ["${var.forward_cookies_whitelisted_names}"]
      }
    }

    viewer_protocol_policy = "${var.viewer_protocol_policy}"
    default_ttl            = "${var.default_ttl}"
    min_ttl                = "${var.min_ttl}"
    max_ttl                = "${var.max_ttl}"
  }
  
  ordered_cache_behavior {
    path_pattern           = "img/*.jpg"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-westpac-demo"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }
 
  custom_error_response {
	error_code					= "400"
	error_caching_min_ttl		= "300"
	response_code				= "200"
	response_page_path			= "${var.cf_aws_errorpage_path_var}"
  }

  custom_error_response {
	error_code					= "403"
	error_caching_min_ttl		= "300"
	response_code				= "200"
	response_page_path			= "${var.cf_aws_errorpage_path_var}"
  }

  custom_error_response {
	error_code					= "404"
	error_caching_min_ttl		= "300"
	response_code				= "200"
	response_page_path			= "${var.cf_aws_errorpage_path_var}"
  }
  
  custom_error_response {
	error_code					= "405"
	error_caching_min_ttl		= "300"
	response_code				= "200"
	response_page_path			= "${var.cf_aws_errorpage_path_var}"
  }

  custom_error_response {
	error_code					= "414"
	error_caching_min_ttl		= "300"
	response_code				= "200"
	response_page_path			= "${var.cf_aws_errorpage_path_var}"
  }

   custom_error_response {
        error_code                  = "500"
        error_caching_min_ttl   	= "300"
        response_code               = "200"
        response_page_path          = "${var.cf_aws_errorpage_path_var}"
  }

  custom_error_response {
        error_code                  = "501"
        error_caching_min_ttl   	= "300"
        response_code               = "200"
        response_page_path          = "${var.cf_aws_errorpage_path_var}"
  }

  custom_error_response {
        error_code                  = "502"
        error_caching_min_ttl   	= "300"
        response_code               = "200"
        response_page_path          = "${var.cf_aws_errorpage_path_var}"
  }

  custom_error_response {
        error_code                  = "503"
        error_caching_min_ttl   	= "300"
        response_code               = "200"
        response_page_path          = "${var.cf_aws_errorpage_path_var}"
  }

  custom_error_response {
        error_code                  = "504"
        error_caching_min_ttl   	= "300"
        response_code               = "200"
        response_page_path          = "${var.cf_aws_errorpage_path_var}"
  }
  web_acl_id = "${var.web_acl_id}"

  restrictions {
    geo_restriction {
      restriction_type = "${var.geo_restriction_type}"
      locations        = "${var.geo_restriction_locations}"
    }
  }

  #tags = "${module.distribution_label.tags}"
}
