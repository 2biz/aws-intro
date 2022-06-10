variable aws_access_key {}
variable aws_secret_key {}
variable upload_bucket_name {}
variable mail_bucket_name {}
variable email_address {}
variable recipients_address {}
variable s_zone_id {}
variable domain_name {}
variable ses_record_name {}
variable dkim_record_name {}
variable acm_domain_name {}
variable mail_bucket_resource {}
variable AWS_INTRO_SAMPLE_HOST {}
variable AWS_INTRO_SAMPLE_SMTP_ADDRESS {}
variable AWS_INTRO_SAMPLE_SMTP_USERNAME {}
variable AWS_INTRO_SAMPLE_SMTP_PASSWORD {}

terraform {
  required_version = ">= 0.12.28"
  required_providers {
    aws = ">= 2.70.0"
  }
}


#### terraform.tfvarsから読み込む
### Terraform実行ユーザアクセスキー ####################
provider "aws" {
  region  = "ap-northeast-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "aws" {
  alias = "east"
  region = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
