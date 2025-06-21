variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "staging"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "wordlist"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "domain" {
  description = "The base domain name.  A subdomain will be added for non-production environments."
  type        = string
  nullable    = false
}

variable "openai_api_key" {
  description = "OpenAI API Key"
  type        = string
  nullable    = false
}

variable "openai_model_name" {
  description = "OpenAI Model Name"
  type        = string
  nullable    = false
}

variable "batch_poll_schedule" {
  description = "Schedule for batch polling in EventBridge format, e.g. rate(30 minutes)"
  type        = string
  default     = "rate(30 minutes)"
}

variable "word_attributes" {
  description = "Word attributes to be scored"
  type = list(object({
    name        = string
    display     = string
    description = string
    prompt      = string
  }))
  default = [
    {
      name        = "commonness"
      display     = "Commonness"
      description = "How common the word is"
      prompt      = "An integer from 0 (extremely rare or unused) to 5 (extremely common)."
    },
    {
      name        = "offensiveness"
      display     = "Offensiveness"
      description = "How offensive the word is"
      prompt      = "An integer from 0 to 5. Use 0 if the word is completely inoffensive; use a number greater than 0 only if it is widely recognized as profanity, a slur, or inherently derogatory."
    },
    {
      name        = "sentiment"
      description = "How positive or negative the word is"
      display     = "Sentiment"
      prompt      = "An integer ranging from -5 (extremely negative) to 5 (extremely positive) that reflects the word's emotional tone."
    },
    {
      name        = "formality"
      description = "How formal the word is"
      display     = "Formality"
      prompt      = "An integer from 0 (extremely informal) to 5 (highly formal)."
    },
    {
      name        = "culturalsensitivity"
      description = "How culturally sensitive the word is"
      display     = "Cultural Sensitivity"
      prompt      = " An integer from 0 (potentially culturally insensitive or laden with stereotypes) to 5 (culturally neutral or widely acceptable)."
    },
    {
      name        = "figurativeness"
      description = "How figurative the word is"
      display     = "Figurativeness"
      prompt      = "An integer from 0 (strictly literal) to 5 (almost exclusively metaphorical)."
    },
    {
      name        = "complexity"
      description = "How complex the word is"
      display     = "Complexity"
      prompt      = "An integer from 0 (simple) to 5 (highly conceptually or structurally complex)."
    },
    {
      name        = "political"
      description = "The degree to which the word pertains to political contexts"
      display     = "Political Association"
      prompt      = "An integer from 0 to 5 measuring the degree to which a word explicitly pertains to political ideologies, entities, debates, or policies. A score of 5 indicates strong and consistent presence in political contexts; 0 indicates no discernible political relevance."
    }
  ]
  nullable = false
}

variable "words_table_name" {
  description = "CockroachDB table name for words"
  type        = string
  default     = "words"
}

locals {
  base_domain = var.domain
  subdomain   = var.environment == "production" ? local.base_domain : "${var.environment}.${local.base_domain}"
}
