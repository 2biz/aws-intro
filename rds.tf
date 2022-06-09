# ====================
#
# RDS DBサーバー
#
# ====================
resource "aws_db_parameter_group" "sample-db-pg" {
    name = "sample-db-pg"
    family = "mysql8.0"
    description = "sample parameter group"
}

resource "aws_db_option_group" "sample-db-og" {
  name                     = "sample-db-og"
  option_group_description = "sample option group"
  engine_name              = "mysql"
  major_engine_version     = "8.0"
}

resource "aws_db_subnet_group" "sample-db-subnet" {
  name       = "sample-db-subnet"
  subnet_ids = [aws_subnet.sample-subnet-private01.id, aws_subnet.sample-subnet-private02.id]
  description = "sample db subnet"
}

resource "aws_db_instance" "sample-db" {
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  username                = "admin"
  password                = "password"
  parameter_group_name    = aws_db_parameter_group.sample-db-pg.name
  vpc_security_group_ids  = [aws_default_security_group.default.id]
  db_subnet_group_name    = aws_db_subnet_group.sample-db-subnet.name
  option_group_name       = aws_db_option_group.sample-db-og.name
  skip_final_snapshot  = true
}

output "rds_address" {
  value = "${aws_db_instance.sample-db.address}"
}