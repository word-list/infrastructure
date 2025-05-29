provider "aws" {
  alias = "application"
}

provider "aws" {
  default_tags {
    tags = merge(
      aws_servicecatalogappregistry_application.wordlist.application_tag,
      {
        Environment = var.environment
        Project     = var.project
      },
    )
  }
}
