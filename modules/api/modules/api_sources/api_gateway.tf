
resource "aws_apigatewayv2_integration" "sources" {
  api_id                 = var.api_id
  integration_uri        = aws_lambda_function.api_sources.invoke_arn
  integration_type       = "AWS_PROXY"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "sources_route" {
  api_id    = var.api_id
  route_key = "GET /api/sources"
  target    = "integrations/${aws_apigatewayv2_integration.sources.id}"
}

resource "aws_apigatewayv2_route" "post_sources" {
  api_id               = var.api_id
  route_key            = "POST /api/sources"
  authorization_type   = "JWT"
  authorizer_id        = var.authorizer_id
  authorization_scopes = ["https://${local.subdomain}/write"]
  target               = "integrations/${aws_apigatewayv2_integration.sources.id}"
}

resource "aws_apigatewayv2_route" "put_sources" {
  api_id               = var.api_id
  route_key            = "PUT /api/sources"
  authorization_type   = "JWT"
  authorizer_id        = var.authorizer_id
  authorization_scopes = ["https://${local.subdomain}/write"]
  target               = "integrations/${aws_apigatewayv2_integration.sources.id}"
}

resource "aws_apigatewayv2_route" "delete_sources" {
  api_id               = var.api_id
  route_key            = "DELETE /api/sources"
  authorization_type   = "JWT"
  authorizer_id        = var.authorizer_id
  authorization_scopes = ["https://${local.subdomain}/write"]
  target               = "integrations/${aws_apigatewayv2_integration.sources.id}"
}

