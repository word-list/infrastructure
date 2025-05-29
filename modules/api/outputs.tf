output "hosted_zone_ns_records" {
  value       = aws_route53_zone.domain.name_servers
  description = "The nameservers for the hosted zone"
}
