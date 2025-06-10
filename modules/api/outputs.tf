output "domain_name" {
  value = replace(aws_apigatewayv2_api.wordlist.api_endpoint, "/^https?://([^/]*).*/", "$1")
}
