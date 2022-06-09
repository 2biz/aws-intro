############################################################
### IAM
############################################################
resource "aws_iam_role" "sample-role-web" {
  name = "sample-role-web"
  description = "upload images"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
            "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "sample-web-profile" {
    name = "sample-role-web"
    path = "/"
    role = aws_iam_role.sample-role-web.name
}

resource "aws_iam_role_policy_attachment" "sample-role-web" {
  role       = aws_iam_role.sample-role-web.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

