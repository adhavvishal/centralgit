resource "aws_lb" "test" {
  name               = "test-lb-tf11"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ssh-allowed.id]
  subnets            = [aws_subnet.public-subnet.id,aws_subnet.public-subnet1.id]

  enable_deletion_protection = false

}

resource "aws_lb_target_group" "test-tg" {
  name     = "lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.test-vpc.id}"
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test-tg.arn
  target_id        = aws_instance.demo-instance-1.id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test-tg.arn
  }
}
