# ====================
#
# Route53
#
# ====================


resource "aws_route53_record" "bastion" {
 zone_id = var.s_zone_id
 name = "bastion"
 type = "A"
 ttl = 300
 
 records = [ aws_instance.sample-ec2-bastion.public_ip ]
}

resource "aws_route53_record" "www" {
 zone_id = var.s_zone_id
 name = "www"
 type = "A"
 alias {
    name                   = aws_lb.sample-elb.dns_name
    zone_id                = aws_lb.sample-elb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_zone" "home" {
  name = "home"
  vpc {
     vpc_id = aws_vpc.sample-vpc.id
  }
}

resource "aws_route53_record" "db_home" {
 zone_id = aws_route53_zone.home.zone_id
 name = "db"
 type = "CNAME"
 ttl = 300
 
 records = [ aws_db_instance.sample-db.address ]
}

resource "aws_route53_record" "bastion_home" {
 zone_id = aws_route53_zone.home.zone_id
 name = "bastion"
 type = "A"
 ttl = 300
 
 records = [ aws_instance.sample-ec2-bastion.private_ip ]
}

resource "aws_route53_record" "web01_home" {
 zone_id = aws_route53_zone.home.zone_id
 name = "web01"
 type = "A"
 ttl = 300
 
 records = [ aws_instance.sample-ec2-web01.private_ip ]
}

resource "aws_route53_record" "web02_home" {
 zone_id = aws_route53_zone.home.zone_id
 name = "web02"
 type = "A"
 ttl = 300
 
 records = [ aws_instance.sample-ec2-web02.private_ip ]
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.s_zone_id
}

resource "aws_route53_record" "ses_record" {
  zone_id = var.s_zone_id
  name    = var.ses_record_name
  type    = "TXT"
  ttl     = "600"
  records = [ "${aws_ses_domain_identity.sample-domain.verification_token}" ]
}

resource "aws_route53_record" "dkim_record" {
  count   = 3
  zone_id = var.s_zone_id
  name    = "${element(aws_ses_domain_dkim.sample-domain.dkim_tokens, count.index)}.dkim_record_name"
  type    = "CNAME"
  ttl     = "600"
  records = [ "${element(aws_ses_domain_dkim.sample-domain.dkim_tokens, count.index)}.dkim_record_records" ]
}

resource "aws_route53_record" "example_ses_domain_mail_from_mx" {
  zone_id = var.s_zone_id
  name    = var.domain_name
  type    = "MX"
  ttl     = "600"
  records = ["10 inbound-smtp.us-east-1.amazonaws.com"]
}

resource "aws_route53_record" "elasticache_home" {
 zone_id = aws_route53_zone.home.zone_id
 name = "elasticache"
 type = "CNAME"
 ttl = 300
 
 records = [ aws_elasticache_replication_group.sample-elasticache.configuration_endpoint_address ]
}