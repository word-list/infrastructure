resource "aws_acm_certificate" "wordlist" {
  provider          = aws.us-east-1
  domain_name       = local.subdomain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "wordlist_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.wordlist.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.domain.id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "wordlist_cert" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.wordlist.arn
  validation_record_fqdns = [for record in aws_route53_record.wordlist_cert_validation : record.fqdn]
}
