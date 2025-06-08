output "hosted_zone_ns_records" {
  value       = module.api.hosted_zone_ns_records
  description = "The nameservers for the hosted zone"
}

output "db_connection_string" {
  value       = data.cockroach_connection_string.app_user.connection_string
  description = "SQL db connection string"
  sensitive   = true
}
