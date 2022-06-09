# ====================
#
# SES
#
# ====================

resource "aws_ses_domain_identity" "sample-domain" {
  provider = aws.east
  domain = var.domain_name
}

resource "aws_ses_domain_dkim" "sample-domain" {
  provider = aws.east
  domain = var.domain_name
}

resource "aws_ses_domain_mail_from" "sample-domain" {
  provider = aws.east
  domain           = aws_ses_domain_identity.sample-domain.domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.sample-domain.domain}"
}

resource "aws_ses_email_identity" "sample-domain" {
  provider = aws.east
  email = var.email_address
}

resource "aws_ses_receipt_rule_set" "sample-rule-set-inquiry" {
  provider = aws.east
  rule_set_name = "sample-rule-set-inquiry"
}

resource "aws_ses_receipt_rule" "sample-rule-inquiry" {
  provider = aws.east
  name          = "sample-rule-inquiry"
  rule_set_name = "sample-rule-set-inquiry"
  recipients    = [var.recipients_address]
  enabled       = true
  scan_enabled  = true

  s3_action {
    bucket_name = var.mail_bucket_name
    position    = 1
  }
}

resource "aws_ses_active_receipt_rule_set" "sample-rule-set-inquiry" {
  provider = aws.east
  rule_set_name = "sample-rule-set-inquiry"
   depends_on = [
    aws_ses_receipt_rule_set.sample-rule-set-inquiry
  ]
}
