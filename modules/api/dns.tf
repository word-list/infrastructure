resource "aws_apigatewayv2_domain_name" "gaultech" {
  domain_name = local.subdomain

  domain_name_configuration {
    certificate_arn = var.wordlist_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

}

resource "aws_apigatewayv2_api_mapping" "custom_domain_mapping" {
  api_id      = aws_apigatewayv2_api.wordlist.id
  domain_name = aws_apigatewayv2_domain_name.gaultech.domain_name
  stage       = aws_apigatewayv2_stage.default.name
}
