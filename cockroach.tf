resource "cockroach_cluster" "default" {
  name           = "${var.project}-${var.environment}-db-cluster"
  cloud_provider = "AWS"
  plan           = "BASIC"
  serverless = {
    usage_limits = {
      request_unit_limit = 50000000
      storage_mib_limit  = 10000000
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
