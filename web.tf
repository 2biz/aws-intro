############################################################
### Webサーバー01 
############################################################
resource "aws_instance" "sample-ec2-web01" {
  ami                    = "ami-02c3627b04781eada"
  instance_type          = "t2.micro"

  key_name = "nakagaki"
  
  subnet_id   = aws_subnet.sample-subnet-private01.id
  security_groups = [aws_default_security_group.default.id]
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.sample-web-profile.id
  tags = {
    Name = "sample-ec2-web01"
  }
  depends_on = [
    aws_nat_gateway.sample-ngw-01,
    aws_route53_record.db_home
  ]
  
  user_data = <<EOF
  #!/bin/bash


sudo yum -y install git gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel libffi-devel libxml2 libxslt libxml2-devel libxslt-devel sqlite-devel libcurl-devel mysql mysql-devel ImageMagick
sudo amazon-linux-extras install -y nginx1

sudo cat <<'EOT' >/etc/nginx/conf.d/rails.conf
upstream puma {
  server unix:///var//www/aws-intro-sample/tmp/sockets/puma.sock;
}
server {
  listen 3000 default_server;
  listen [::]:3000 default_server;
  server_name puma;
  
  location ~ ^/assets/ {
    root /var/www/aws-intro-sample/public;
  }
  
  location / {
    proxy_read_timeout 300;
    proxy_connect_timeout 300;
    proxy_redirect off;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://puma;
  }
}
EOT

sudo adduser deploy
sudo mkdir -p /var/www
sudo chown deploy:deploy /var/www

sudo systemctl restart nginx.service

sudo cat <<'EOT' > /home/deploy/setup.sh
#!/bin/bash
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(~/.rbenv/bin/rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

rbenv install 2.6.6
rbenv global 2.6.6
gem install rails -v 5.1.6

mysql -h db.home -u admin -ppassword -e "create database sample_app;"
mysql -h db.home -u admin -ppassword -e "create user sample_app identified by 'password';"
mysql -h db.home -u admin -ppassword -e "grant all privileges on sample_app.* to sample_app@'%';"

cd /var/www
git clone https://github.com/nakaken0629/aws-intro-sample.git
cd /var/www/aws-intro-sample

bundle install
secret=`rails secret`
AWS_INTRO_SAMPLE_HOST="${var.AWS_INTRO_SAMPLE_HOST}"
AWS_INTRO_SAMPLE_S3_BUCKET="${var.upload_bucket_name}"
AWS_INTRO_SAMPLE_SMTP_DOMAIN="${var.domain_name}"
AWS_INTRO_SAMPLE_SMTP_ADDRESS="${var.AWS_INTRO_SAMPLE_SMTP_ADDRESS}"
AWS_INTRO_SAMPLE_SMTP_USERNAME="${var.AWS_INTRO_SAMPLE_SMTP_USERNAME}"
AWS_INTRO_SAMPLE_SMTP_PASSWORD="${var.AWS_INTRO_SAMPLE_SMTP_PASSWORD}"

echo export SECRET_KEY_BASE=$secret >> ~/.bash_profile
echo 'export AWS_INTRO_SAMPLE_DATABASE_PASSWORD=password' >> ~/.bash_profile
echo export AWS_INTRO_SAMPLE_HOST=$AWS_INTRO_SAMPLE_HOST >> ~/.bash_profile
echo 'export AWS_INTRO_SAMPLE_S3_REGION=ap-northeast-1' >> ~/.bash_profile
echo export AWS_INTRO_SAMPLE_S3_BUCKET=$AWS_INTRO_SAMPLE_S3_BUCKET >> ~/.bash_profile
echo 'export AWS_INTRO_SAMPLE_REDIS_ADDRESS=elasticache.home' >> ~/.bash_profile
echo export AWS_INTRO_SAMPLE_SMTP_DOMAIN=$AWS_INTRO_SAMPLE_SMTP_DOMAIN >> ~/.bash_profile
echo export AWS_INTRO_SAMPLE_SMTP_ADDRESS=$AWS_INTRO_SAMPLE_SMTP_ADDRESS >> ~/.bash_profile
echo export AWS_INTRO_SAMPLE_SMTP_USERNAME=$AWS_INTRO_SAMPLE_SMTP_USERNAME >> ~/.bash_profile
echo export AWS_INTRO_SAMPLE_SMTP_PASSWORD=$AWS_INTRO_SAMPLE_SMTP_PASSWORD >> ~/.bash_profile
source ~/.bash_profile
rails db:migrate RAILS_ENV=production
rails assets:precompile RAILS_ENV=production
echo $secret
rails server -e production
EOT

EOF
}

############################################################
### Webサーバー02 
############################################################
resource "aws_instance" "sample-ec2-web02" {
  ami                    = "ami-02c3627b04781eada"
  instance_type          = "t2.micro"

  key_name = "nakagaki"
  
  subnet_id   = aws_subnet.sample-subnet-private02.id
  security_groups = [aws_default_security_group.default.id]
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.sample-web-profile.id

  tags = {
    Name = "sample-ec2-web02"
  }
  depends_on = [
    aws_nat_gateway.sample-ngw-02,
    aws_route53_record.db_home
  ]
  
  user_data = <<EOF
  #!/bin/bash


sudo yum -y install git gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel libffi-devel libxml2 libxslt libxml2-devel libxslt-devel sqlite-devel libcurl-devel mysql mysql-devel ImageMagick
sudo amazon-linux-extras install -y nginx1

sudo cat <<'EOT' >/etc/nginx/conf.d/rails.conf
upstream puma {
  server unix:///var//www/aws-intro-sample/tmp/sockets/puma.sock;
}
server {
  listen 3000 default_server;
  listen [::]:3000 default_server;
  server_name puma;
  
  location ~ ^/assets/ {
    root /var/www/aws-intro-sample/public;
  }
  
  location / {
    proxy_read_timeout 300;
    proxy_connect_timeout 300;
    proxy_redirect off;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://puma;
  }
}
EOT

sudo adduser deploy
sudo mkdir -p /var/www
sudo chown deploy:deploy /var/www

sudo systemctl restart nginx.service

sudo cat <<'EOT' > /home/deploy/setup.sh
#!/bin/bash
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(~/.rbenv/bin/rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

rbenv install 2.6.6
rbenv global 2.6.6
gem install rails -v 5.1.6


cd /var/www
git clone https://github.com/nakaken0629/aws-intro-sample.git
cd /var/www/aws-intro-sample

bundle install
AWS_INTRO_SAMPLE_HOST="${var.AWS_INTRO_SAMPLE_HOST}"
AWS_INTRO_SAMPLE_S3_BUCKET="${var.upload_bucket_name}"
AWS_INTRO_SAMPLE_SMTP_DOMAIN="${var.domain_name}"
AWS_INTRO_SAMPLE_SMTP_ADDRESS="${var.AWS_INTRO_SAMPLE_SMTP_ADDRESS}"
AWS_INTRO_SAMPLE_SMTP_USERNAME="${var.AWS_INTRO_SAMPLE_SMTP_USERNAME}"
AWS_INTRO_SAMPLE_SMTP_PASSWORD="${var.AWS_INTRO_SAMPLE_SMTP_PASSWORD}"

echo export SECRET_KEY_BASE=$secret >> ~/.bash_profile
echo 'export AWS_INTRO_SAMPLE_DATABASE_PASSWORD=password' >> ~/.bash_profile
echo export AWS_INTRO_SAMPLE_HOST=$AWS_INTRO_SAMPLE_HOST >> ~/.bash_profile
echo 'export AWS_INTRO_SAMPLE_S3_REGION=ap-northeast-1' >> ~/.bash_profile
echo export AWS_INTRO_SAMPLE_S3_BUCKET=$AWS_INTRO_SAMPLE_S3_BUCKET >> ~/.bash_profile
echo 'export AWS_INTRO_SAMPLE_REDIS_ADDRESS=elasticache.home' >> ~/.bash_profile
echo export AWS_INTRO_SAMPLE_SMTP_DOMAIN=$AWS_INTRO_SAMPLE_SMTP_DOMAIN >> ~/.bash_profile
echo export AWS_INTRO_SAMPLE_SMTP_ADDRESS=$AWS_INTRO_SAMPLE_SMTP_ADDRESS >> ~/.bash_profile
echo export AWS_INTRO_SAMPLE_SMTP_USERNAME=$AWS_INTRO_SAMPLE_SMTP_USERNAME >> ~/.bash_profile
echo export AWS_INTRO_SAMPLE_SMTP_PASSWORD=$AWS_INTRO_SAMPLE_SMTP_PASSWORD >> ~/.bash_profile
source ~/.bash_profile
rails assets:precompile RAILS_ENV=production
rails server -e production
EOT
  EOF
}