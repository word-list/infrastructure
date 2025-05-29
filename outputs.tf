output "hosted_zone_ns_records" {
  value       = module.api.hosted_zone_ns_records
  description = "The nameservers for the hosted zone"
}
