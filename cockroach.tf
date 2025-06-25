resource "cockroach_cluster" "default" {
  name           = "${var.project}-${var.environment}-db-cluster"
  cloud_provider = "AWS"
  plan           = "BASIC"
  serverless = {
    usage_limits = {
      request_unit_limit = 50000000
      storage_mib_limit  = 10000
    }
  }
  regions           = [{ name = var.region }]
  delete_protection = false
}

resource "random_password" "db_user_password" {
  length           = 16
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "!@#$%^&*()-_=+[]{}<>:?"
}

resource "cockroach_sql_user" "app_user" {
  name       = "app_user"
  password   = random_password.db_user_password.result
  cluster_id = cockroach_cluster.default.id
}

resource "cockroach_database" "default" {
  name       = "${var.project}-${var.environment}-db"
  cluster_id = cockroach_cluster.default.id
}

data "cockroach_connection_string" "app_user" {
  id       = cockroach_cluster.default.id
  sql_user = cockroach_sql_user.app_user.name
  password = random_password.db_user_password.result
  database = cockroach_database.default.name
}

locals {
  alter_statements = join("\n ", [
    for attr in local.word_attributes :
    "ALTER TABLE ${var.words_table_name} ADD COLUMN IF NOT EXISTS ${attr.name} INT;"
  ])
}
resource "local_file" "words_table" {
  content  = <<-EOT
    CREATE TABLE IF NOT EXISTS ${var.words_table_name} (
      text TEXT PRIMARY KEY
    );
    ${local.alter_statements}
  EOT
  filename = "${path.module}/words_table.sql"

  depends_on = [cockroach_cluster.default]
}

resource "null_resource" "apply_words_schema" {
  triggers = {
    file_sha = sha256(local_file.words_table.content)
  }

  provisioner "local-exec" {
    command = <<EOT
psql \
  -h ${data.cockroach_connection_string.app_user.connection_params.host} \
  -p 26257 \
  -d ${cockroach_database.default.name} \
  -U ${data.cockroach_connection_string.app_user.sql_user} \
  -f ${path.module}/words_table.sql
EOT
    environment = {
      PGPASSWORD = data.cockroach_connection_string.app_user.password
    }
  }

  depends_on = [local_file.words_table, data.cockroach_connection_string.app_user]
}
