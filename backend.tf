terraform {
  backend "s3" {
    bucket  = "wordlist-staging-infrastructure-state"
    key     = "terraform/state.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}
