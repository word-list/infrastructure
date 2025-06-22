resource "aws_lambda_function" "api_words" {
  function_name    = "${var.project}-${var.environment}-api-words"
  handler          = "WordList.Api.Words"
  runtime          = "dotnet8"
  role             = aws_iam_role.api_words.arn
  architectures    = ["arm64"]
  filename         = "placeholder.zip"
  source_code_hash = filebase64sha256("placeholder.zip")
  timeout          = 60
  environment {
    variables = {
      DB_CONNECTION_STRING = var.db_connection_string
    }
  }
}

resource "aws_lambda_permission" "api_words_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_words.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_execution_arn}/*"
}
