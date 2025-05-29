module "api_sources" {
  source                                 = "./modules/api_sources"
  project                                = var.project
  environment                            = var.environment
  domain                                 = var.domain
  region                                 = var.region
  sources_table_name                     = var.sources_table_name
  sources_table_policy_arn               = var.sources_table_policy_arn
  deployment_artifacts_bucket_policy_arn = var.deployment_artifacts_bucket_policy_arn
  api_gateway_execution_arn              = aws_apigatewayv2_api.wordlist.execution_arn
  api_id                                 = aws_apigatewayv2_api.wordlist.id
  authorizer_id                          = aws_apigatewayv2_authorizer.cognito_auth.id
}
