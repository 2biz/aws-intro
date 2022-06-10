# はじめに 
""AWSではじめるインフラ構築入門""という本の構成をTerraformを利用して構築出来るようにファイルを作りました。  
利用するためには一部GUIで設定する箇所もあるため、この本を読みながら進める必要があります。  
一般常識の範囲でご利用ください。  
検証はしておりますが、ご利用において一切責任を負わないので注意してご利用ください。  


# 使い方 
##1. terraform.tfvarsファイルを環境に合わせて修正します。  
　※terraform.tfvarsファイルは変数を記載したファイルです。  
| 変数名                         | 説明 |
| ----                           | ---- |
| aws_access_key                 | P.43～52を参考にIAMユーザーを作成します。注意点としてはアクセスの種類を「プログラムによるアクセス」とする必要があります。作成したらアクセスキーIDを入力します。|
| aws_secret_key                 | 作成したアクセスキーIDに対応するシークレットキーを入力します。|
| acm_domain_name                | WEBサーバのFQDNを入力します。[www.ドメイン名 となります。]|
| s_zone_id                      | Route53に予めドメインを設定しておく必要があります。P.206～212を参考に取得しても良いですし、他手段もあります。設定したドメインのゾーンIDを入力します。|
| domain_name                    | 予めドメインを設定したドメイン名を入力します。|
| ses_record_name                | SESで利用します。[_amazonses.ドメイン名]のように入力します。|
| dkim_record_name               | SESで利用します。[_domainkey.ドメイン名]のように入力します。|
| upload_bucket_name             | S3のアップロード用バケット名を入力します。同じリージョン内で重複しない名前を指定する必要があります。|
| mail_bucket_name               | S3のメール受信用バケット名を入力します。同じリージョン内で重複しない名前を指定する必要があります。|
| mail_bucket_resource           | S3のメール受信用バケットのARNを入力します。|
| email_address                  | P.258で追加するアドレスに該当するメールアドレスを追加します。|
| recipients_address             | P.266で追加するアドレスに該当するメールアドレスを追加します。|
| AWS_INTRO_SAMPLE_HOST          | WEBのURLを入力します。|
| AWS_INTRO_SAMPLE_SMTP_ADDRESS  | P.262のメールサーバのアドレスを入力します。|
| AWS_INTRO_SAMPLE_SMTP_USERNAME | P.263のアクセスキーを入力します。|
| AWS_INTRO_SAMPLE_SMTP_PASSWORD | P.263のシークレットキーを入力します。|
  
##2.SSHキーペアをP.102～104に従い作成します。
  
##3.通常のTerraformの構築手順に従います。(自分の環境はWindows11です。)  
　cd aws-intro  
　terraform init  
　terraform plan  
　terraform apply  
  
##4.3.が完了後、P.235～236のSSH設定をしてからSSHでweb01に接続して下記を実行します。  
　sudo su - deploy  
　bash setup.sh  
　完了すると、「Use Ctrl-C to stop」と表示されます。  
  
##5.4.が完了後、SSHでweb02に接続して下記を実行します。  
　sudo su - deploy  
　bash setup.sh  
　完了すると、「Use Ctrl-C to stop」と表示されます。  
  
##6.この時点でP.303の状態になっていると思います。動作確認をしてみてください。  
