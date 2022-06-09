# はじめに 
"AWSではじめるインフラ構築入門"という本の構成をTerraformを利用して構築出来るようにファイルを作りました。  
一部GUIで設定する箇所もあるため、この本を読みながら進める必要があります。  
一般常識の範囲でご利用ください。  
検証はしておりますが、ご利用において一切責任を負わないので注意してご利用ください。  


# 使い方 
1.[terraform.tfvars]ファイルは変数のファイルです。ご利用者の環境に合わせて必要な情報を修正します。  
・aws_access_key:P.43～52を参考にIAMユーザーを作成します。注意点としてはアクセスの種類を「プログラムによるアクセス」とする必要があります。作成したらアクセスキーIDを入力します。  
・aws_secret_key:作成したアクセスキーIDに対応するシークレットキーを入力します。  
・acm_domain_name:WEBサーバのFQDNを入力します。(基本的に www.ドメイン名 となります。)  
・s_zone_id:Route53に予めドメインを設定しておく必要があります。P.206～212を参考に取得しても良いですし、他手段もあります。設定したドメインのゾーンIDを入力します。  
・domain_name:予めドメインを設定したドメイン名を入力します。  
・ses_record_name:SESで利用します。[_amazonses.ドメイン名]のように入力します。  
・dkim_record_name:SESで利用します。[_domainkey.ドメイン名]のように入力します。  
・upload_bucket_name:S3のアップロード用バケット名を入力します。同じリージョン内で重複しない名前を指定する必要があります。  
・mail_bucket_name:S3のメール受信用バケット名を入力します。同じリージョン内で重複しない名前を指定する必要があります。  
・upload_resource:S3のメール受信用バケットのARNを入力します。  
・email_address:P.258で追加するアドレスに該当するメールアドレスを追加します。  
・recipients_address:P.266で追加するアドレスに該当するメールアドレスを追加します。  
・AWS_INTRO_SAMPLE_HOST:WEBのURLを入力します。  
・AWS_INTRO_SAMPLE_SMTP_ADDRESS:P.262のメールサーバのアドレスを入力します。  
・AWS_INTRO_SAMPLE_SMTP_USERNAME:P.263のアクセスキーを入力します。  
・AWS_INTRO_SAMPLE_SMTP_PASSWORD:P.263のシークレットキーを入力します。  
  
2.通常のTerraformの構築手順に従います。(自分の環境はWindows11です。)  
　cd aws-intro  
　terraform init  
　terraform plan  
　terraform apply  
  
3.完了後、SSHでweb01に接続して下記を実行します。  
　sudo su - deploy  
　bash setup.sh  
  
4.SSHでweb02に接続して下記を実行します。  
　sudo su - deploy  

　/home/deploy/setup.shの"SECRET_KEY_BASE="を修正します。  
　web01と同じ文字列をコピー＆ペーストして保存します。  
　不明な場合は、web01で/home/deploy/.bash_profileを確認してください。  
　修正後下記コマンドを実行します。
　bash setup.sh  
  
5.この時点でP.303の状態になっていると思います。動作確認をしてみてください。  
