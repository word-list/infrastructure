terraform {
  required_providers {
    cockroach = {
      source = "cockroachdb/cockroach"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

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

# Specifically for Cloudfront certificate
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "cockroach" {
}
