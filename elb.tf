############################################################
### ロードバランサ―
############################################################
resource "aws_lb" "sample-elb" {
  name               = "sample-elb"
  internal           = false
  load_balancer_type = "application"

  security_groups    = [
    aws_security_group.sample-sg-elb.id,
    aws_default_security_group.default.id
  ]

  subnets            = [
      aws_subnet.sample-subnet-public01.id,
      aws_subnet.sample-subnet-public02.id
  ]
  
}
#resource "aws_lb_listener" "sample-elb" {
#  load_balancer_arn = aws_lb.sample-elb.arn
#  port              = "80"
#  protocol          = "HTTP"

#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.sample-tg.arn
#  }

#}
resource "aws_lb_listener" "sample-elb" {
  load_balancer_arn = aws_lb.sample-elb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sample-tg.arn
  }

}

resource "aws_lb_listener_rule" "forward" {
  listener_arn = aws_lb_listener.sample-elb.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sample-tg.arn
  }

  condition {
      path_pattern{
        values = ["/*"]
      }
  }
}

resource "aws_lb_target_group" "sample-tg" {
  name        = "sample-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.sample-vpc.id

  health_check {
        path        = "/index.html"
  }
}

resource "aws_lb_target_group_attachment" "sample-ec2-web01" {
  target_group_arn = aws_lb_target_group.sample-tg.arn
  target_id        = aws_instance.sample-ec2-web01.id
  port             = 3000
}

resource "aws_lb_target_group_attachment" "sample-ec2-web02" {
  target_group_arn = aws_lb_target_group.sample-tg.arn
  target_id        = aws_instance.sample-ec2-web02.id
  port             = 3000
}