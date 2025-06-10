resource "aws_route53_zone" "domain" {
  name = local.subdomain
}

resource "aws_route53_record" "wordlist_alias" {
  zone_id = aws_route53_zone.domain.id
  name    = local.subdomain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate_validation" "wordlist_cert" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.wordlist.arn
  validation_record_fqdns = [for record in aws_route53_record.wordlist_cert_validation : record.fqdn]
}
