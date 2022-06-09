############################################################
### ネットワーク 
############################################################
### VPC ####################
resource "aws_vpc" "sample-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "sample-vpc"
  }
}

### サブネット ####################
# 外部サブネット1
resource "aws_subnet" "sample-subnet-public01" {
  vpc_id                  = aws_vpc.sample-vpc.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "sample-subnet-public01"
  }
}

# 外部サブネット2
resource "aws_subnet" "sample-subnet-public02" {
  vpc_id                  = aws_vpc.sample-vpc.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "sample-subnet-public02"
  }
}

# 内部サブネット1
resource "aws_subnet" "sample-subnet-private01" {
  vpc_id                  = aws_vpc.sample-vpc.id
  cidr_block              = "10.0.64.0/20"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "sample-subnet-private01"
  }
}

# 内部サブネット2
resource "aws_subnet" "sample-subnet-private02" {
  vpc_id                  = aws_vpc.sample-vpc.id
  cidr_block              = "10.0.80.0/20"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "sample-subnet-private02"
  }
}

### ネットワークルーティング ####################
# インターネットゲートウェイ
resource "aws_internet_gateway" "sample-igw" {
  vpc_id = aws_vpc.sample-vpc.id
  tags = {
    Name = "sample-igw"
  }
}


# NATゲートウェイ1
# EIPを作成
resource "aws_eip" "nat_gateway1" {
  vpc = true
}

resource "aws_nat_gateway" "sample-ngw-01" {
  allocation_id = aws_eip.nat_gateway1.id
  subnet_id     = aws_subnet.sample-subnet-public01.id

  tags = {
    Name = "sample-ngw-01"
  }
}

# NATゲートウェイ2
# EIPを作成
resource "aws_eip" "nat_gateway2" {
  vpc = true
}

resource "aws_nat_gateway" "sample-ngw-02" {
  allocation_id = aws_eip.nat_gateway2.id
  subnet_id     = aws_subnet.sample-subnet-public02.id

  tags = {
    Name = "sample-ngw-02"
  }
}

# パブリックサブネット用（共通）
resource "aws_route_table" "sample-rt-public" {
  vpc_id = aws_vpc.sample-vpc.id
  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.sample-igw.id
  }
  tags = {
    Name = "sample-rt-public"
  }
}

resource "aws_route_table_association" "sample-rt-public01" {
  subnet_id     = "${aws_subnet.sample-subnet-public01.id}"
  route_table_id = aws_route_table.sample-rt-public.id
}

resource "aws_route_table_association" "sample-rt-public02" {
  subnet_id     = "${aws_subnet.sample-subnet-public02.id}"
  route_table_id = aws_route_table.sample-rt-public.id
}


# プライベートサブネット1用
resource "aws_route_table" "sample-rt-private01" {
  vpc_id = aws_vpc.sample-vpc.id
  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_nat_gateway.sample-ngw-01.id
  }
  tags = {
    Name = "sample-rt-private01"
  }
}

resource "aws_route_table_association" "sample-rt-private01" {
  subnet_id      = aws_subnet.sample-subnet-private01.id
  route_table_id = aws_route_table.sample-rt-private01.id
}

# プライベートサブネット2用
resource "aws_route_table" "sample-rt-private02" {
  vpc_id = aws_vpc.sample-vpc.id
  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_nat_gateway.sample-ngw-02.id
  }
  tags = {
    Name = "sample-rt-private02"
  }
}

resource "aws_route_table_association" "sample-rt-private02" {
  subnet_id      = aws_subnet.sample-subnet-private02.id
  route_table_id = aws_route_table.sample-rt-private02.id
}

############################################################
### セキュリティグループ 
############################################################
# セキュリティグループ：default
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.sample-vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# セキュリティグループ：sample-sg-bastion
resource "aws_security_group" "sample-sg-bastion" {
  name   = "sample-sg-bastion"
  description = "for bastion server"
  vpc_id = aws_vpc.sample-vpc.id

  tags = {
    Name = "sample-sg-bastion"
  }
}

# アウトバウンド(外に出る)ルール
resource "aws_security_group_rule" "sample-sg-bastion-out-all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sample-sg-bastion.id
}

# インバウンド(受け入れる)ルール
# SSH(22/TCP)
resource "aws_security_group_rule" "sample-sg-bastion-in-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sample-sg-bastion.id
}

# セキュリティグループ：sample-sg-elb
resource "aws_security_group" "sample-sg-elb" {
  name   = "sample-sg-elb"
  description = "for load balancer"
  vpc_id = aws_vpc.sample-vpc.id

  tags = {
    Name = "sample-sg-elb"
  }
}

# アウトバウンド(外に出る)ルール
resource "aws_security_group_rule" "sample-sg-elb-out-all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sample-sg-elb.id
}

# インバウンド(受け入れる)ルール
# HTTP(80/TCP)
resource "aws_security_group_rule" "sample-sg-elb-in-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sample-sg-elb.id
}

# HTTPS(443/TCP)
resource "aws_security_group_rule" "sample-sg-elb-in-https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sample-sg-elb.id
}
