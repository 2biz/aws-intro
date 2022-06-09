############################################################
### 踏み台サーバ 
############################################################
resource "aws_instance" "sample-ec2-bastion" {
  ami                    = "ami-02c3627b04781eada"
  instance_type          = "t2.micro"

  key_name = "nakagaki"
  
  subnet_id   = aws_subnet.sample-subnet-public01.id
  security_groups = [
      aws_security_group.sample-sg-bastion.id,
      aws_default_security_group.default.id
      ]
  associate_public_ip_address = true

  tags = {
    Name = "sample-ec2-bastion"
  }
}