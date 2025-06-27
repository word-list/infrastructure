# infrastructure

## Description

This repository contains the Terraform code used to deploy the infrastructure used by the Word List application.

The infrastructure currently looks like this:

```mermaid
flowchart LR;
    subgraph Cloudflare
        dns[Domain NS Records]
    end
    subgraph CockroachDB
        words_db[(words db)]
    end
    subgraph GitHub
        deployments[[lib-sql workflow]] ==> words_db
    end
    subgraph AWS
        cloudfront[Cloudfront]
        api_gateway[API Gateway]
        route_53[Route 53]

        certificate[ACM Certificate]

        api_words[[api-words]]
        api_sources[[api-sources]]
        api_attributes[[api-attributes]]

        upload_source_chunks[[upload-source-chunks]]
        process_source_chunk[[process-source-chunk]]
        query_words[[query-words]]

        check_batches[[check-batches]]
        update_batch[[update-batch]]
        update_words[[update-words]]

        chunk_bucket@{shape: lin-cyl, label: "chunk-bucket"}
        frontend_bucket@{shape: lin-cyl, label: "frontend-bucket"}
        artifact_bucket@{shape: lin-cyl, label: "deployment-artifacts"}

        process_source_chunk_queue@{shape: paper-tape, label: "process-source-chunk-queue"}
        query_words_queue@{shape: paper-tape, label: "query-words-queue"}
        update_batch_queue@{shape: paper-tape, label: "update-batch-queue"}
        update_words_queue@{shape: paper-tape, label: "update-words-queue"}

        sources_table[(sources-table)]
        batches_table[(batches-table)]
        prompts_table[(prompts-table)]
        attributes_table[(attributes-table)]
        source_update_status_table[(source-update-status-table)]

        route_53 --> certificate --> cloudfront

        frontend_bucket --> cloudfront
        route_53 -- via update script --> dns

        cloudfront
            --> api_gateway
            --> api_words
        api_gateway --> api_sources
        api_gateway --> api_attributes

        upload_source_chunks
            -..-> process_source_chunk_queue
            -..-> process_source_chunk
            -..-> query_words_queue
            -..-> query_words

        upload_source_chunks --> chunk_bucket --> process_source_chunk
        upload_source_chunks --> source_update_status_table
        process_source_chunk --> source_update_status_table

        words_db --> api_words
        words_db --> query_words

        sources_table <--> api_sources
        sources_table --> upload_source_chunks

        attributes_table --> api_attributes
        attributes_table --> api_words
        attributes_table --> query_words
        attributes_table --> update_words

        query_words --> batches_table
        query_words --> prompts_table
        query_words --> source_update_status_table

        batches_table
            --> check_batches
            -..-> update_batch_queue
            -..-> update_batch
            -..-> update_words_queue
            -..-> update_words --> words_db

        update_batch -..-> query_words_queue
        update_batch  --> source_update_status_table
        update_words --> source_update_status_table

        prompts_table --> update_batch

        artifact_bucket -..-> upload_source_chunks
        artifact_bucket -..-> process_source_chunk
        artifact_bucket -..-> query_words
        artifact_bucket -..-> check_batches
        artifact_bucket -..-> update_batch
        artifact_bucket -..-> update_words

    end
```

## Inputs

The Terraform has the following variables:

| Variable Name       | Description                                                                      | Type   | Default Value          | Nullable |
|---------------------|----------------------------------------------------------------------------------|--------|------------------------|----------|
| environment         | Deployment environment                                                           | string | staging                | No       |
| project             | Project name                                                                     | string | wordlist               | No       |
| region              | AWS region                                                                       | string | eu-west-2              | No       |
| domain              | The base domain name. A subdomain will be added for non-production environments. | string | N/A                    | No       |
| openai_api_key      | OpenAI API Key                                                                   | string | N/A                    | No       |
| openai_model_name   | OpenAI Model Name                                                                | string | N/A                    | No       |
| batch_poll_schedule | Schedule for batch polling in EventBridge format, e.g. rate(30 minutes)          | string | rate(30 minutes)       | No       |

Infrastructure is created using the environment and project names, so e.g. `update-words-queue` would be created as `wordlist-staging-update-words-queue` with the defaults above.

## Scripts

### init.sh

Sets up the state bucket and initialises the Terraform backend, creating the `backend.tf` file.

#### Environment Variables

| Variable Name        | Description                                          | Default Value |
|----------------------|------------------------------------------------------|---------------|
| LOG_FILE             | Log file for the script.                             | init.log      |
| ENVIRONMENT          | The environment name, e.g. staging                   | N/A           |
| PROJECT              | The name of the project.                             | wordlist      |
| REGION               | The AWS region infrastructure will be deployed to.   | eu-west-2     |

### update-dns.sh

Updates Cloudflare DNS NS records using the output from the Terraform deployment.

Uses `terraform output`, so will only work after the infrastructure has been applied.

#### Environment Variables

| Variable Name        | Description                                          | Default Value |
|----------------------|------------------------------------------------------|---------------|
| ZONE_ID              | The ID of the Cloudflare zone to be updated.         | N/A           |
| DOMAIN_NAME          | The name of the domain to be updated.                | N/A           |
| CLOUDFLARE_API_TOKEN | The Cloudflare API token to use when updating zones. | N/A           |

### update-lib-sql-connection-string.sh

Updates the connection string secret in a GitHub repository using the CockroachDB information from the Terraform deployment.

Uses `terraform output`, so will only work after the infrastructure has been applied.

#### Environment Variables

| Variable Name        | Description                                          | Default Value |
|----------------------|------------------------------------------------------|---------------|
| ENVIRONMENT          | The environment name, e.g. staging.                  | N/A           |
| SQL_REPO_NAME        | The name of the GitHub repo to be updated.           | N/A           |
| GH_TOKEN             | The GitHub API token to use when updating.           | N/A           |
| SQL_SECRET_NAME      | The name of the secret to be updated.                | N/A           |
