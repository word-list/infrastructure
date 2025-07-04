module "api" {
  source                                 = "./modules/api"
  project                                = var.project
  environment                            = var.environment
  region                                 = var.region
  domain                                 = var.domain
  sources_table_name                     = aws_dynamodb_table.sources.name
  sources_table_policy_arn               = aws_iam_policy.sources_table.arn
  deployment_artifacts_bucket_policy_arn = aws_iam_policy.deployment_artifacts_bucket.arn
  db_connection_string                   = data.cockroach_connection_string.app_user.connection_string
  wordlist_certificate_arn               = aws_acm_certificate.wordlist.arn
  word_attributes_table_name             = aws_dynamodb_table.word_attributes.name
  word_attributes_table_policy_arn       = aws_iam_policy.word_attributes_table.arn

  depends_on = [aws_acm_certificate_validation.wordlist_cert]
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
  source_update_status_table_name        = aws_dynamodb_table.source_update_status.name
  source_update_status_table_policy_arn  = aws_iam_policy.source_update_status_table.arn
}

module "process_source_chunk" {
  source                                = "./modules/process_source_chunk"
  project                               = var.project
  environment                           = var.environment
  region                                = var.region
  source_chunks_bucket_name             = aws_s3_bucket.source_chunks.bucket
  source_chunks_bucket_policy_arn       = aws_iam_policy.source_chunks_bucket.arn
  source_chunks_table_name              = aws_dynamodb_table.source_chunks.name
  source_chunks_table_policy_arn        = aws_iam_policy.source_chunks_table.arn
  query_words_queue_policy_arn          = module.query_words.query_words_queue_policy_arn
  query_words_queue_url                 = module.query_words.query_words_queue_url
  db_connection_string                  = data.cockroach_connection_string.app_user.connection_string
  source_update_status_table_name       = aws_dynamodb_table.source_update_status.name
  source_update_status_table_policy_arn = aws_iam_policy.source_update_status_table.arn
}

module "query_words" {
  source                                = "./modules/query_words"
  project                               = var.project
  environment                           = var.environment
  region                                = var.region
  batches_table_name                    = aws_dynamodb_table.batches.name
  batches_table_policy_arn              = aws_iam_policy.batches_table.arn
  prompts_table_name                    = aws_dynamodb_table.prompts.name
  prompts_table_policy_arn              = aws_iam_policy.prompts_table.arn
  openai_api_key                        = var.openai_api_key
  openai_model_name                     = var.openai_model_name
  word_attributes_table_name            = aws_dynamodb_table.word_attributes.name
  word_attributes_table_policy_arn      = aws_iam_policy.word_attributes_table.arn
  source_update_status_table_name       = aws_dynamodb_table.source_update_status.name
  source_update_status_table_policy_arn = aws_iam_policy.source_update_status_table.arn
}

module "check_batches" {
  source                                = "./modules/check_batches"
  project                               = var.project
  environment                           = var.environment
  region                                = var.region
  batches_table_name                    = aws_dynamodb_table.batches.name
  batches_table_policy_arn              = aws_iam_policy.batches_table.arn
  prompts_table_name                    = aws_dynamodb_table.prompts.name
  prompts_table_policy_arn              = aws_iam_policy.prompts_table.arn
  openai_api_key                        = var.openai_api_key
  openai_model_name                     = var.openai_model_name
  batch_poll_schedule                   = var.batch_poll_schedule
  update_batch_queue_url                = module.update_batch.update_batch_queue_url
  update_batch_queue_policy_arn         = module.update_batch.update_batch_queue_policy_arn
  source_update_status_table_name       = aws_dynamodb_table.source_update_status.name
  source_update_status_table_policy_arn = aws_iam_policy.source_update_status_table.arn
}

module "update_batch" {
  source                                = "./modules/update_batch"
  project                               = var.project
  environment                           = var.environment
  region                                = var.region
  batches_table_name                    = aws_dynamodb_table.batches.name
  batches_table_policy_arn              = aws_iam_policy.batches_table.arn
  prompts_table_name                    = aws_dynamodb_table.prompts.name
  prompts_table_policy_arn              = aws_iam_policy.prompts_table.arn
  openai_api_key                        = var.openai_api_key
  update_words_queue_url                = module.update_words.update_words_queue_url
  update_words_queue_policy_arn         = module.update_words.update_words_queue_policy_arn
  query_words_queue_url                 = module.query_words.query_words_queue_url
  query_words_queue_policy_arn          = module.query_words.query_words_queue_policy_arn
  word_attributes_table_name            = aws_dynamodb_table.word_attributes.name
  word_attributes_table_policy_arn      = aws_iam_policy.word_attributes_table.arn
  source_update_status_table_name       = aws_dynamodb_table.source_update_status.name
  source_update_status_table_policy_arn = aws_iam_policy.source_update_status_table.arn
}

module "update_words" {
  source                                = "./modules/update_words"
  project                               = var.project
  environment                           = var.environment
  region                                = var.region
  db_connection_string                  = data.cockroach_connection_string.app_user.connection_string
  word_attributes_table_name            = aws_dynamodb_table.word_attributes.name
  word_attributes_table_policy_arn      = aws_iam_policy.word_attributes_table.arn
  source_update_status_table_name       = aws_dynamodb_table.source_update_status.name
  source_update_status_table_policy_arn = aws_iam_policy.source_update_status_table.arn
}
