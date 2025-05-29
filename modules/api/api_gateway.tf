resource "aws_apigatewayv2_api" "wordlist" {
  name          = "${var.project}-${var.environment}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.wordlist.id
  name        = var.environment
  auto_deploy = true # Enables automatic deployment when changes occur
}
