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
