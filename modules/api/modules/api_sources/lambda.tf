resource "aws_lambda_function" "api_sources" {
  function_name    = "${var.project}-${var.environment}-api-sources"
  handler          = "bootstrap"
  runtime          = "provided.al2023"
  role             = aws_iam_role.api_sources.arn
  filename         = "placeholder.zip"
  source_code_hash = filebase64sha256("placeholder.zip")
  architectures    = ["arm64"]
  environment {
    variables = {
      SOURCES_TABLE_NAME = var.sources_table_name
    }
  }
}

resource "aws_lambda_permission" "api_sources_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_sources.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_execution_arn}/*"
}
