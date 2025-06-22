
resource "aws_apigatewayv2_integration" "attributes" {
  api_id                 = var.api_id
  integration_uri        = aws_lambda_function.api_attributes.invoke_arn
  integration_type       = "AWS_PROXY"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "GET_attributes" {
  api_id    = var.api_id
  route_key = "GET /api/attributes"
  target    = "integrations/${aws_apigatewayv2_integration.attributes.id}"
}
