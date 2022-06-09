### Terraform実行ユーザアクセスキー ####################
#事前にプログラムで AWS を呼び出すことができるIAMユーザを作成してPowerUserAccess,IAMFullAccessポリシーをアタッチする
aws_access_key    = "INPUT" #IAMユーザーのアクセスキーID
aws_secret_key    = "INPUT" #IAMユーザーのシークレットアクセスキー


### ACM ################################################
acm_domain_name = "www.hoge-example.com" #WEBサーバーのFQDN


### Route53 ############################################
#事前にパブリックで利用するドメインを登録しておく
s_zone_id = "INPUT" #ゾーンID
domain_name = "hoge-example.com"
ses_record_name = "_amazonses.hoge-example.com"
dkim_record_name = "_domainkey.hoge-example.com"
dkim_record_records = "dkim.amazonses.com"


### S3 #################################################
upload_bucket_name = "aws-intro-sample-upload.2biz.jp" #Upload用のS3バケット名
mail_bucket_name = "aws-intro-sample-mailbox.2biz.jp"  #Mail用のS3バケット名
upload_resource = "arn:aws:s3:::aws-intro-sample-mailbox.2biz.jp/*" #Upload用のS3バケットのARN

### SES ################################################
email_address = "INPUT" #検証済メールアドレス
recipients_address = "INPUT" #受信用メールアドレス

### WEB ################################################
AWS_INTRO_SAMPLE_HOST = "https://www.hoge-example.com"  #WEBサーバーのURL
AWS_INTRO_SAMPLE_SMTP_ADDRESS = "email-smtp.us-east-1.amazonaws.com" #SMTPサーバのアドレス
AWS_INTRO_SAMPLE_SMTP_USERNAME = "INPUT" #SMTP認証用のIAMユーザのアクセスキーID
AWS_INTRO_SAMPLE_SMTP_PASSWORD = "INPUT" #SMTP認証用のIAMユーザのシークレットアクセスキー