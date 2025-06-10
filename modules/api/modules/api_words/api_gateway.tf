
resource "aws_apigatewayv2_integration" "words" {
  api_id                 = var.api_id
  integration_uri        = aws_lambda_function.api_words.invoke_arn
  integration_type       = "AWS_PROXY"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "GET_words" {
  api_id    = var.api_id
  route_key = "GET /api/words"
  target    = "integrations/${aws_apigatewayv2_integration.words.id}"
}
