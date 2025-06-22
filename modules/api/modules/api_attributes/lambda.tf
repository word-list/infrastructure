resource "aws_lambda_function" "api_attributes" {
  function_name    = "${var.project}-${var.environment}-api-attributes"
  handler          = "bootstrap"
  runtime          = "provided.al2023"
  role             = aws_iam_role.api_attributes.arn
  filename         = "placeholder.zip"
  source_code_hash = filebase64sha256("placeholder.zip")
  architectures    = ["arm64"]
  environment {
    variables = {
      DB_CONNECTION_STRING = var.db_connection_string
    }
  }
}

resource "aws_lambda_permission" "api_attributes_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_attributes.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_execution_arn}/*"
}
