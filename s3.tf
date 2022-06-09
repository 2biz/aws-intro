############################################################
### S3  
############################################################


resource "aws_s3_bucket" "aws-intro-sample-upload" {
  bucket = var.upload_bucket_name
  force_destroy = true
  
  tags = {
    Name        = "aws-intro-sample-upload"
  }
}

resource "aws_s3_bucket_public_access_block" "private" {
  bucket                  = aws_s3_bucket.aws-intro-sample-upload.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "aws-intro-sample-mailbox" {
  bucket = var.mail_bucket_name
  force_destroy = true
  
  tags = {
    Name        = "aws-intro-sample-mailbox"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.aws-intro-sample-mailbox.id
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AllowSESPuts",
      "Effect":"Allow",
      "Principal":{
        "Service":"ses.amazonaws.com"
      },
      "Action":"s3:PutObject",
      "Resource":"${var.upload_resource}"
    }
  ]
}
EOF
}

