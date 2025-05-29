resource "aws_route53_zone" "domain" {
  name = local.subdomain
}

resource "aws_route53_record" "api_alias" {
  zone_id = aws_route53_zone.domain.id
  name    = local.subdomain
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.gaultech.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.gaultech.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate_validation" "api_cert" {
  certificate_arn         = aws_acm_certificate.api.arn
  validation_record_fqdns = [for record in aws_route53_record.api_cert_validation : record.fqdn]
}

resource "aws_apigatewayv2_domain_name" "gaultech" {
  domain_name = local.subdomain

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.api.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [aws_acm_certificate_validation.api_cert]
}

resource "aws_apigatewayv2_api_mapping" "custom_domain_mapping" {
  api_id      = aws_apigatewayv2_api.wordlist.id
  domain_name = aws_apigatewayv2_domain_name.gaultech.domain_name
  stage       = aws_apigatewayv2_stage.default.name
}
