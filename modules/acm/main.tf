resource "aws_acm_certificate" "domain_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain" {
  name            = tolist(aws_acm_certificate.domain_cert.domain_validation_options)[0].resource_record_name
  type            = "CNAME"
  zone_id         = var.host_zone_id
  records         = [tolist(aws_acm_certificate.domain_cert.domain_validation_options)[0].resource_record_value]
  ttl             = 300
  allow_overwrite = true
}

resource "aws_route53_record" "cert_validation_records" {
  allow_overwrite = true
  zone_id         = var.host_zone_id
  ttl             = 300

  for_each = {
    for dvo in aws_acm_certificate.domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.domain_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_records : record.fqdn]

  timeouts {
    create = "5m"
  }
}

