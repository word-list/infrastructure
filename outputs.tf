output "hosted_zone_ns_records" {
  value       = aws_route53_zone.domain.name_servers
  description = "The nameservers for the hosted zone"
}

output "db_connection_string" {
  value       = data.cockroach_connection_string.app_user.connection_string
  description = "SQL db connection string"
  sensitive   = true
}
