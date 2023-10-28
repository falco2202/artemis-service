output "certificate_arn" {
  value = aws_acm_certificate.domain_cert.arn
}

output "certificate" {
  value = aws_acm_certificate.domain_cert
}
