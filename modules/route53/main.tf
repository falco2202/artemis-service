resource "aws_route53_record" "alias_domain" {
  zone_id = var.host_zone_id
  name    = var.host_domain
  type    = "A"

  alias {
    name                   = var.app_lb.dns_name
    zone_id                = var.app_lb.zone_id
    evaluate_target_health = true
  }
}
