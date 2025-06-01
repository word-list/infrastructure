module "api" {
  source                                 = "./modules/api"
  project                                = var.project
  environment                            = var.environment
  region                                 = var.region
  domain                                 = var.domain
  sources_table_name                     = aws_dynamodb_table.sources.name
  sources_table_policy_arn               = aws_iam_policy.sources_table.arn
  deployment_artifacts_bucket_policy_arn = aws_iam_policy.deployment_artifacts_bucket.arn
}

module "upload_source_chunks" {
  source                                 = "./modules/upload_source_chunks"
  project                                = var.project
  environment                            = var.environment
  region                                 = var.region
  source_chunks_bucket_name              = aws_s3_bucket.source_chunks.bucket
  source_chunks_table_name               = aws_dynamodb_table.source_chunks.name
  source_chunks_bucket_policy_arn        = aws_iam_policy.source_chunks_bucket.arn
  source_chunks_table_policy_arn         = aws_iam_policy.source_chunks_table.arn
  sources_table_name                     = aws_dynamodb_table.sources.name
  sources_table_policy_arn               = aws_iam_policy.sources_table.arn
  process_source_chunk_queue_url         = module.process_source_chunk.process_source_chunk_queue_url
  process_source_chunks_queue_policy_arn = module.process_source_chunk.process_source_chunk_queue_policy_arn
  deployment_artifacts_bucket_policy_arn = aws_iam_policy.deployment_artifacts_bucket.arn
}

module "process_source_chunk" {
  source                          = "./modules/process_source_chunk"
  project                         = var.project
  environment                     = var.environment
  region                          = var.region
  source_chunks_bucket_name       = aws_s3_bucket.source_chunks.bucket
  source_chunks_bucket_policy_arn = aws_iam_policy.source_chunks_bucket.arn
  source_chunks_table_name        = aws_dynamodb_table.source_chunks.name
  source_chunks_table_policy_arn  = aws_iam_policy.source_chunks_table.arn
  query_words_queue_policy_arn    = module.query_words.query_words_queue_policy_arn
  query_words_queue_url           = module.query_words.query_words_queue_url
  words_table_name                = aws_dynamodb_table.words.name
  words_table_policy_arn          = aws_iam_policy.words_table.arn
}

module "query_words" {
  source                   = "./modules/query_words"
  project                  = var.project
  environment              = var.environment
  region                   = var.region
  words_table_name         = aws_dynamodb_table.words.name
  words_table_policy_arn   = aws_iam_policy.words_table.arn
  batches_table_name       = aws_dynamodb_table.batches.name
  batches_table_policy_arn = aws_iam_policy.batches_table.arn
  prompts_table_name       = aws_dynamodb_table.prompts.name
  prompts_table_policy_arn = aws_iam_policy.prompts_table.arn
  openai_api_key           = var.openai_api_key
}
