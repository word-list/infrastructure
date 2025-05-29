resource "aws_apigatewayv2_authorizer" "cognito_auth" {
  api_id          = aws_apigatewayv2_api.wordlist.id
  authorizer_type = "JWT"
  name            = "CognitoJWTAuth"

  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.wordlist_user_auth.id}"
    audience = [aws_cognito_user_pool_client.default.id]
  }
}

resource "aws_cognito_user_pool" "wordlist_user_auth" {
  name = "${var.project}-${var.environment}-auth-pool"

  auto_verified_attributes = ["email"]

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = false
  }
}

resource "aws_cognito_resource_server" "wordlist_server" {
  name         = "${var.project}-${var.environment}-resource-server"
  user_pool_id = aws_cognito_user_pool.wordlist_user_auth.id
  identifier   = "https://${local.subdomain}"

  scope {
    scope_name        = "write"
    scope_description = "Allows write access to wordlist API"
  }
}

resource "aws_cognito_user_pool_client" "default" {
  name         = "${var.project}-${var.environment}-app-client"
  user_pool_id = aws_cognito_user_pool.wordlist_user_auth.id

  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["openid", "email", "https://${local.subdomain}/write"]

  explicit_auth_flows          = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  supported_identity_providers = ["COGNITO"]

  callback_urls = ["https://${local.subdomain}/auth/callback"]

  depends_on = [
    aws_cognito_user_pool.wordlist_user_auth,
    aws_cognito_resource_server.wordlist_server
  ]
}
