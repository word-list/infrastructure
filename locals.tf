
locals {
  base_domain = var.domain
  subdomain   = var.environment == "production" ? local.base_domain : "${var.environment}.${local.base_domain}"

  word_attributes = [
    {
      name        = "commonness"
      display     = "Commonness"
      description = "How common the word is"
      prompt      = "An integer from $MIN (extremely rare or unused) to $MAX (extremely common).",
      min         = 0
      max         = 5
    },
    {
      name        = "offensiveness"
      display     = "Offensiveness"
      description = "How offensive the word is"
      prompt      = "An integer from $MIN to $MAX. Use $MIN if the word is completely inoffensive; use a number greater than $MIN only if it is widely recognized as profanity, a slur, or inherently derogatory."
      min         = 0
      max         = 5
    },
    {
      name        = "sentiment"
      description = "How positive or negative the word is"
      display     = "Sentiment"
      prompt      = "An integer ranging from $MIN (extremely negative) to $MAX (extremely positive) that reflects the word's emotional tone."
      min         = -5
      max         = 5
    },
    {
      name        = "formality"
      description = "How formal the word is"
      display     = "Formality"
      prompt      = "An integer from $MIN (extremely informal) to $MAX (highly formal)."
      min         = 0
      max         = 5
    },
    {
      name        = "culturalsensitivity"
      description = "How culturally sensitive the word is"
      display     = "Cultural Sensitivity"
      prompt      = " An integer from $MIN (potentially culturally insensitive or laden with stereotypes) to $MAX (culturally neutral or widely acceptable)."
      min         = 0
      max         = 5
    },
    {
      name        = "figurativeness"
      description = "How figurative the word is"
      display     = "Figurativeness"
      prompt      = "An integer from $MIN (strictly literal) to $MAX (almost exclusively metaphorical)."
      min         = 0
      max         = 5
    },
    {
      name        = "complexity"
      description = "How complex the word is"
      display     = "Complexity"
      prompt      = "An integer from $MIN (simple) to $MAX (highly conceptually or structurally complex)."
      min         = 0
      max         = 5
    },
    {
      name        = "political"
      description = "The degree to which the word pertains to political contexts"
      display     = "Political Association"
      prompt      = "An integer from $MIN to $MAX measuring the degree to which a word explicitly pertains to political ideologies, entities, debates, or policies. A score of $MAX indicates strong and consistent presence in political contexts; $MIN indicates no discernible political relevance."
      min         = 0
      max         = 5
    },
    {
      name        = "nsfw"
      description = "Whether the word is inappropriate or unsuitable for use in professional or workplace settings"
      display     = "NSFW"
      prompt      = "An integer from $MIN to $MAX representing the degree to which the word is not safe for work (NSFW). A score of $MAX indicates the word is highly inappropriate for workplace use, including profanity, explicit or sexual language, offensive slang, or suggestive content. A score of $MIN means the word is fully safe for professional environments."
      min         = 0
      max         = 1
    }
  ]
}
