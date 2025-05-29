resource "aws_servicecatalogappregistry_application" "wordlist" {
  provider    = aws.application
  name        = "${var.project}-${var.environment}-application"
  description = "Infrastructure for Wordlist application"
}
